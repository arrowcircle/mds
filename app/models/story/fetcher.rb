#coding: utf-8
require 'open-uri'
require 'nokogiri'

module Story::Fetcher
  include Story::Fetcher::Extractors
  URL = "http://mds-club.ru/cgi-bin/index.cgi?r=84&lang=rus&sbr=1&posits=0&filter=0&article=0&sortby=20&search="

  def to_fetch_date
    date.nil? ? nil : date.strftime("%d.%m.%Y")
  end

  def to_search_string
    "#{URL}#{CGI::escape(name.downcase.force_encoding('windows-1251').encode('Windows-1251','UTF-8'))}"
  end

  def fetch_search_results
    Nokogiri::HTML(open(to_search_string))
  end

  def results
    @results ||= get_results
  end

  def get_results
    fetch_search_results.search("#catalogtable center table tbody tr").collect do |tr|
      parse_result_tr(tr)
    end
  end

  def get_many_results_string(results_hash)
    res = "#{Time.now.strftime('%d.%m.%Y')}: Найдено несколько результатов, необходимо уточнить: <br/>"
    results_hash.each do |r|
      res << "#{r[:position]} ---- #{r[:date]} (#{r[:station]})} <br/>"
    end
    res
  end

  def get_station text
    case text
      when "Станция" then 0
      when "Муз-ТВ" then 1
      when "Пионер FM" then 4
      when "Подкаст" then 6
      when "Станция 106.8" then 7
      when "Серебряный дождь" then 2
      when "NRJ" then 3
      when "Энергия" then 3
      else 5
    end
  end

  def update_links links_array
    if links_array.size > 1
      self.links.destroy_all
      links_array[1..-1].each do |lnk|
        Link.create(story_id: id, link: lnk)
      end
    end
  end

  def parse_story_page url
    doc = Nokogiri::HTML(open(url))
    info = doc.search("#attachtitle").inner_text.gsub("Вернуться в каталог", "").split("\n").map(&:squish)
    links_array = extract_links_array(doc)
    air_date = extract_air_date(info[2])
    station = get_station(info[4].gsub("Радиостанция: ", ""))
    attrs = {}
    attrs.merge!(radio: station) if station
    attrs.merge!(link: links_array[0]) if links_array.size > 0
    attrs.merge!(date: air_date) if air_date
    attrs.merge!(last_fetched_at: Time.now, fetcher_comment: nil, parsed: true)
    update_attributes(attrs)
    update_links(links_array)
  end

  def parse_pack_of_results results
    if date
      stry = results.find {|x| date.strftime("%d.%m.%Y") == x[:date]}
      if stry
        parse_story_page(stry[:link_to_page])
      else
        update_attributes(fetcher_comment: get_many_results_string(res), last_fetched_at: Time.now)
      end
    else
      # try to find page with date
      update_attributes(fetcher_comment: get_many_results_string(res), last_fetched_at: Time.now)
    end
  end

  def update_no_results
    update_attributes(fetcher_comment: "#{Time.now.strftime('%d.%m.%Y')}: Найдено 0 результатов, попробуйте уточнить название рассказа", last_fetched_at: Time.now)
  end

  # main method
  def parse_info_from_site
    if results.count == 0
      update_no_results
    elsif results.count == 1
      parse_story_page(results.first[:link_to_page])
      # open and parse page
    elsif results.count > 1
      parse_pack_of_results(results)
    end
  end
end