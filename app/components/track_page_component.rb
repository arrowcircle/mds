class TrackPageComponent < ViewComponent::Base
  attr_reader :artist, :track, :stories, :current_user
  def initialize(artist:, track:, stories:, current_user: nil)
    @artist = artist
    @track = track
    @stories = stories
    @current_user = current_user
  end

  def buttons
    [
      PageTitleButtonComponent.new(title: "Добавить", icon: "images/add.svg", link: [:new, :artist], mobile_visible: true)
    ]
  end

  def title
    return "Играет в рассказах" if @artists.present?
    "Мы не нашли такого артиста"
  end

  def metadata
    []
  end
end
