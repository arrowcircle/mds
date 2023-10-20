AUTHOR_DUPES = {}
namespace :import do
  task all: [:users, :authors, :stories, :artists, :tracks, :playlists]

  task users: :environment do
    FileUtils.rm_f("tmp/minio/images/*")
    puts "\n== Importing users\n"
    KEYS = [:id, :email, :created_at, :role, :username].map(&:to_s)
    Old::User.find_in_batches do |batch|
      batch.each do |ou|
        user = User.find_by(id: ou.id)
        user ||= User.new
        KEYS.each do |k|
          user[k] = ou[k] unless user[k].present?
        end
        user.email ||= user.username
        unless user.avatar.present?
          if ou.avatar.present?
            user.avatar_remote_url = "https://mds.redde.ru/uploads/user/avatar/#{ou.id}/#{ou.avatar}"
          end
        end
        if user.save
          print "."
        else
          print "x"
          if Old::Playlist.where(user_id: ou.id).any? || Old::Playlist.where(identified_by: ou.id).any?
            puts "\n== User have playlists, attention: "
            puts user.errors.map(&:full_message)
            puts user.email
          else
            puts "\n= Delete user with id: #{user.id} email: #{user.email}"
          end
        end
      end
    end
    puts "\nComplete"
  end

  task stories: :environment do
    puts "\n== Importing stories\n"
    delete = []
    Old::Story.find_in_batches do |batch|
      batch.each do |old_story|
        a = Story.find_by(id: old_story.id)
        a ||= Story.new(id: old_story.id)
        %w[name author_id completed radio date].each do |field|
          a.send("#{field}=", old_story.send(field)) unless a.send(field).present?
        end
        dupe_author_id = AUTHOR_DUPES[a.author_id]
        a.author_id = dupe_author_id if dupe_author_id.present?
        if a.save
          print "."
        else
          print "X"
          if Old::Playlist.where(story_id: a.id).any?
            puts "Story with playlists: "
            puts a.errors.map(&:full_message)
            puts a.name
          else
            puts "Story without playlists, delete: "
            puts a.errors.map(&:full_message)
            puts a.name
            puts a.id
            delete << a.id
          end
        end
      end
    end
    puts "\nComplete"
    Story.find_by_sql("SELECT setval('stories_id_seq', COALESCE((SELECT MAX(id)+1 FROM stories), 1), false);")
    Author.all.each { |a| Author.reset_counters(a.id, :stories) }
    if delete.present?
      puts "Story.where(id: [#{delete.join(", ")}]).delete_all"
    end
  end

  task authors: :environment do
    puts "\n== Importing authors\n"
    dupes = {}
    Old::Author.find_in_batches do |batch|
      batch.each do |old_author|
        a = Author.find_by(id: old_author.id)
        a ||= Author.new(id: old_author.id)
        a.name ||= old_author.name
        if a.save
          print "."
        else
          print "X"
          puts a.errors.map(&:full_message)
          puts a.name
          old_ids = Old::Author.where(name: old_author.name).map(&:id)
          new_id = Author.where(name: old_author.name).first.id
          (old_ids - [new_id]).each do |id|
            dupes[id] = new_id
          end
        end
      end
    end
    puts "\nComplete"
    Author.find_by_sql("SELECT setval('authors_id_seq', COALESCE((SELECT MAX(id)+1 FROM authors), 1), false);")
    if dupes.keys.any?
      code = <<~CODE
        author_dupes = #{dupes}

        author_dupes.each do |dupe_id, original_id|
          Story.where(author_id: dupe_id).update_all(author_id: original_id)
        end

        Author.where(id: author_dupes.keys).count
      CODE
      puts code
    end
  end

  task artists: :environment do
    puts "\n== Importing artists\n"
    Old::Artist.find_in_batches do |batch|
      batch.each do |old|
        a = Artist.find_by(id: old.id)
        a ||= Artist.new(id: old.id)
        %w[name].each do |field|
          a.send("#{field}=", old.send(field)) unless a.send(field).present?
        end
        if a.save
          print "."
        else
          print "X"
        end
      end
    end
    puts "\nComplete"
    Artist.find_by_sql("SELECT setval('artists_id_seq', COALESCE((SELECT MAX(id)+1 FROM artists), 1), false);")
  end

  task tracks: :environment do
    puts "\n== Importing tracks\n"
    delete = []
    Old::Track.find_in_batches do |batch|
      batch.each do |old|
        a = Track.find_by(id: old.id)
        a ||= Track.new(id: old.id)
        %w[name artist_id].each do |field|
          a.send("#{field}=", old.send(field)) unless a.send(field).present?
        end
        if a.save
          print "."
        else
          print "X"

          if Old::Playlist.where(track_id: a.id).any?
            puts "Need to deal with it"
            puts a.errors.map(&:full_message)
            puts a.name
            puts a.id
          else
            delete << a.id
          end
        end
      end
    end
    puts "\nComplete"
    Track.find_by_sql("SELECT setval('tracks_id_seq', COALESCE((SELECT MAX(id)+1 FROM tracks), 1), false);")
    Artist.all.each { |a| Artist.reset_counters(a.id, :tracks) }
    if delete.present?
      puts "Track.where(id: [#{delete.join(", ")}]).delete_all"
    end
  end

  task playlists: :environment do
    puts "\n== Importing playlists\n"
    Old::Playlist.find_in_batches do |batch|
      batch.each do |old|
        a = Playlist.find_by(id: old.id)
        a ||= Playlist.new(id: old.id)
        %w[track_id story_id user_id identified_by created_at updated_at].each do |field|
          a.send("#{field}=", old.send(field)) unless a.send(field).present?
        end
        a.start_min = old.startmin
        a.end_min = old.endmin
        if a.save
          print "."
        else
          print "X"
          puts a.errors.map(&:full_message)
        end
      end
    end
    puts "\nComplete"
    Playlist.find_by_sql("SELECT setval('playlists_id_seq', COALESCE((SELECT MAX(id)+1 FROM playlists), 1), false);")
    puts "Updating playlists count on stories"
    Story.all.each { |a| Story.reset_counters(a.id, :playlists) }
    puts "Updating playlists count on tracks"
    Track.all.each { |a| Track.reset_counters(a.id, :playlists) }
    puts "Updating playlists count on users"
    User.all.each { |a| User.reset_counters(a.id, :identified_playlists) }
  end
end
