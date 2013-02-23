module Story::Fetcher::Extractors
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

  def extract_air_date doc
    date_array = get_info(doc)[2].gsub("Дата выхода в эфир: ", "").split(".").reverse
    if date_array.size == 3
      Date.civil(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
    else
      nil
    end
  end

  def get_info doc
    doc.search("#attachtitle").inner_text.gsub("Вернуться в каталог", "").split("\n").map(&:squish)
  end

  def get_station doc
    case get_info(doc)[4].gsub("Радиостанция: ", "")
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

  def extract_links_array doc
    begin
      doc.search("#catalogtable center table tbody tr").collect do |tr|
        tr.search("td")[3].search("a")[0].attributes["href"].value
      end
    rescue
      puts "error parsing links for #{name}"
      nil
    end
  end
end