class Search
  def self.search(query)
    {
      "Пользователи" => User.search(query).to_a,
      "Авторы" => Author.search(query).to_a,
      "Рассказы" => Story.search(query, Story.includes(:author)).to_a,
      "Исполнители" => Artist.search(query).to_a,
      "Треки" => Track.search(query, Track.includes(:artist)).to_a,
    }
  end
end