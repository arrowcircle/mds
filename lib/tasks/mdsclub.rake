require 'open-uri'
require 'net/http'
require 'nokogiri'

namespace :mdsclub do
  task :parse do
    per_page = 50
    pages = 1300/per_page
    current_page = start_page
    write_page start_page
    while current_page <= pages do
      parse_page current_page
      current_page += 1
      write_page current_page
    end
  end

  def get link
    url = URI.parse link
    Nokogiri::HTML(Net::HTTP.get_response(url).body)
  end

  def parse_page page
    puts "parsing page #{page}"
    doc = get page_to_link(page)
    doc.search("#catalogtable tbody tr").each do |tr|
      parse_story(tr)
    end
  end

  def parse_story tr
    begin
      link = tr.search("td a").first.attributes["href"].value
      doc = get link
      if doc.search("#catalogtable tbody").inner_text.index("mp3").nil?
        write_link link
      end
    rescue
    end
  end

  def write_link link
    File.open(File.join("tmp", "stories.txt"), 'a') {|f| f.write "#{link}\n\n"}
  end

  def write_page page
    File.open(File.join("tmp", "current_page.txt"), 'w') {|f| f.write page}
  end

  def page_to_link page
    "http://mds-club.ru/cgi-bin/index.cgi?r=84&lang=rus&filter=0&article=0&sortby=20&posits=#{page*50}&search="
  end

  def start_page
    begin
      File.open(File.join("tmp", "current_page.txt")).read.to_i
    rescue
      0
    end
  end
end