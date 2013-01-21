# coding: utf-8
namespace :story do
  task :fetch_empty_station => :environment do
    puts "Stories without station: #{Story.where("radio is null").count}"
    Story.where("radio is null").where("last_fetched_at < ? or last_fetched_at is null", 1.day.ago).each do |story|
      story.parse_info_from_site
    end
    puts "Stories without station after: #{Story.where("radio is null").count}"
  end
end