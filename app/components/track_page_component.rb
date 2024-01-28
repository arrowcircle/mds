class TrackPageComponent < ViewComponent::Base
  attr_reader :artist, :track, :stories, :current_user

  def initialize(artist:, track:, stories:, current_user: nil)
    @artist = artist
    @track = track
    @stories = stories
    @current_user = current_user
  end

  def buttons
    res = []
    res << PageTitleButtonComponent.new(title: "Редактировать", icon: "images/edit.svg", link: [:edit, artist, track], mobile_visible: true) if current_user&.admin?
    res << PageTitleButtonComponent.new(title: "Назад", icon: "images/arrow_left.svg", link: [artist], mobile_visible: true)
  end

  def title
    res = []
    res << link_to(artist.name, [:artist], class: :link)
    res << "-"
    res << track.name
    raw res.join(" ")
  end
end
