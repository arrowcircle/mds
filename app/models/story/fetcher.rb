#coding: utf-8
require 'open-uri'
require 'nokogiri'

module Story::Fetcher
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

  def extract_position tds
    tds[0].search("a")[1].inner_text
  end

  def extract_link tds
    tds[0].search("a")[1].attributes["href"].value
  end

  def extract_date tds
    tds[3].inner_text
  end

  def extract_tration tds
    tds[5].inner_text
  end

  def parse_result_tr tds
    tds = tr.search("td")
    {}.merge!(:position => extract_position(tds), :link_to_page => extract_link(tds), :date => extract_date(tds), :station => extract_station(tds))
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

  def parse_story_page(url)
    doc = Nokogiri::HTML(open(url))
    info = doc.search("#attachtitle").inner_text.gsub("Вернуться в каталог", "").split("\n").map(&:squish)
    begin
      links_array = doc.search("#catalogtable center table tbody tr").collect do |tr|
        tr.search("td")[3].search("a")[0].attributes["href"].value
      end
    rescue
      puts "error parsing links for #{name}"
    end
    date_array = info[2].gsub("Дата выхода в эфир: ", "").split(".").reverse
    air_date = Date.civil(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i) if date_array.size == 3
    station = get_station(info[4].gsub("Радиостанция: ", ""))
    attrs = {}
    attrs.merge!(radio: station) if station
    attrs.merge!(link: links_array[0]) if links_array.size > 0
    attrs.merge!(date: air_date) if air_date
    attrs.merge!(last_fetched_at: Time.now, fetcher_comment: nil, parsed: true)
    update_attributes(attrs)
    if links_array.size > 1
      links_array[1..-1].each do |lnk|
        self.links.destroy_all
        Link.create(story_id: id, link: lnk)
      end
    end
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