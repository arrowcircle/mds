# coding: utf-8
namespace :story do
  task :fetch => :environment do
    puts "Unparsed stories: #{Story.where(parsed: false).count}"
    unparsed_ids = Story.where(parsed: false).where("last_fetched_at is not null and updated_at > last_fetched_at")).map(&:id)
    new_ids = Story.where(parsed: false).where("last_fetched_at is null")).map(&:id)
    Story.find((unparsed_ids + new_ids).uniq).each do |story|
      story.parse_info_from_site
    end
    puts "Unparsed stories: #{Story.where(parsed: false).count}"
  end
end