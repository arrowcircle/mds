namespace :audio do
  task download: :environment do
    Story.find_in_batches do |batch|
      batch.each do |story|
        next print "." if story.audio.present?
        next print "E" unless story.external_audio_url.present?
        next if story.external_audio_url.index("datagrad")

        # print "⏭"

        url = story.external_audio_url
        url = url.sub(%r{^ftp://}, "http://")

        res = HTTP.follow.get(url)
        next unless res.status == 200

        story.audio_remote_url = url
        if story.save
          print "✅"
        else
          puts story.errors.map(&:full_message)
          print "❌"
        end
      end
      print "\n"
    end

    puts "✅ Done"
  end
end
