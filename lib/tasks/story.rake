# coding: utf-8
namespace :story do
  task :fetch_empty_station => :environment do
    puts "Stories without station: #{Story.where("radio is null").count}"
    Story.where(parsed: false).where("radio is null").where("last_fetched_at < ? or last_fetched_at is null or updated_at > last_fetched_at + interval '1 minute'", 1.day.ago).each do |story|
      story.parse_info_from_site
    end
    puts "Stories without station after: #{Story.where("radio is null").count}"
  end

  task :fetch_empty_date => :environment do
    puts "Stories without date: #{Story.where("date is null").count}"
    Story.where(parsed: false).where("date is null").where("last_fetched_at < ? or last_fetched_at is null or updated_at > last_fetched_at + interval '1 minute'", 1.day.ago).each do |story|
      story.parse_info_from_site
    end
    puts "Stories without date after: #{Story.where("date is null").count}"
  end
  task :fetch_empty_link => :environment do
    puts "Stories without link: #{Story.where("link is null").count}"
    Story.where(parsed: false).where("link is null").where("last_fetched_at < ? or last_fetched_at is null or updated_at > last_fetched_at + interval '1 minute'", 1.day.ago).each do |story|
      story.parse_info_from_site
    end
    puts "Stories without link after: #{Story.where("link is null").count}"
  end

  task :fetch => [:fetch_empty_station, :fetch_empty_date, :fetch_empty_link]
end