# coding: utf-8
namespace :story do
  task :fetch => :environment do
    puts "Unparsed stories: #{Story.where(parsed: false).count}"
    Story.where(parsed: false).where("last_fetched_at is null or (updated_at > last_fetched_at)").each do |story|
      story.parse_info_from_site
    end
    puts "Unparsed stories: #{Story.where(parsed: false).count}"
  end
end