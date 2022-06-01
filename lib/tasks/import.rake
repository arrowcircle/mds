AUTHOR_DUPES = {303=>302, 305=>304, 306=>304, 392=>391, 418=>179, 459=>442}
namespace :import do
  task users: :environment do
    KEYS = [:id, :email, :encrypted_password, :sign_in_count, :last_sign_in_at, :current_sign_in_at, :created_at, :updated_at, :role, :username].map(&:to_s)
    avatars = {}
    users = JSON.parse(File.read('tmp/users.json'))
    users.each_slice(100) do |slice|
      insert = slice.map { |i| i.slice(*KEYS) }
      insert.each do |i|
        i['username'] = i['email'] unless i['username'].present?
        %w(created_at updated_at last_sign_in_at current_sign_in_at).each do |field|
          if i[field].present?
            i[field] = DateTime.strptime(i[field], '%m/%d/%Y %H:%M:%S')
          else
            i[field] = Time.now
          end
        end
      end
      res = User.insert_all(insert, returning: [:id])
      res.rows.each do |id|
        ava = slice.select { |i| i['id'].to_i == id.first.to_i }.try(:first)
        avatars[id.first.to_i] = ava['avatar'] if ava['avatar'].present?
      end
      avatars.each do |id, image|
        u = User.find(id)
        u.avatar_remote_url = "https://mds.redde.ru/uploads/user/avatar/#{id}/#{image}"
        u.save(validate: false)
      end
      avatars = {}
    end
  end
  task authors: :environment do
    dupes = {}
    Old::Author.find_in_batches do |batch|
      batch.each do |old_author|
        a = Author.find_by(id: old_author.id)
        a ||= Author.new(id: old_author.id)
        a.name ||= old_author.name
        if a.save
          print '.'
        else
          print 'X'
          old_ids = Old::Author.where(name: old_author.name).map(&:id)
          new_id = Author.where(name: old_author.name).first.id
          (old_ids - [new_id]).each do |id|
            dupes[id] = new_id
          end
        end
      end
    end
    puts "\nComplete"
    puts dupes
    Author.find_by_sql("SELECT setval('authors_id_seq', COALESCE((SELECT MAX(id)+1 FROM authors), 1), false);")
  end

  task stories: :environment do
    Old::Story.find_in_batches do |batch|
      batch.each do |old_story|
        a = Story.find_by(id: old_story.id)
        a ||= Story.new(id: old_story.id)
        %w(name author_id completed radio date).each do |field|
          a.send("#{field}=", old_story.send(field)) unless a.send(field).present?
        end
        dupe_author_id = AUTHOR_DUPES[a.author_id]
        a.author_id = dupe_author_id if dupe_author_id.present?
        if a.save
          print '.'
        else
          print 'X'
        end
      end
    end
    puts "\nComplete"
    Story.find_by_sql("SELECT setval('stories_id_seq', COALESCE((SELECT MAX(id)+1 FROM stories), 1), false);")
  end
end
