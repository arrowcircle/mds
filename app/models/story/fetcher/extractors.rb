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
end