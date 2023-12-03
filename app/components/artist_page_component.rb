class ArtistPageComponent < ViewComponent::Base
  attr_reader :artist, :tracks, :current_user
  def initialize(artist:, pagy:, tracks: [], query: nil, page: nil, current_user: NullUser.new)
    @artist = artist
    @tracks = tracks
    @pagy = pagy
    @query = query
    @page = page
    @current_user = current_user
  end

  def buttons
    buttons = []
    if current_user.id.present?
      buttons << PageTitleButtonComponent.new(title: "Добавить трек", icon: "images/add.svg", link: [:new, artist, :track], mobile_visible: false)
    end
    if current_user.admin?
      buttons << PageTitleButtonComponent.new(title: "Редактировать", icon: "images/edit.svg", link: [:edit, artist], mobile_visible: false)
    end
    buttons << PageTitleButtonComponent.new(title: "назад", icon: "images/arrow_left.svg", link: :back, mobile_visible: true)
  end

  def title
    artist.name
  end

  def metadata
    return ["Всего: #{@pagy.count}"] if @pagy.count > 0
    []
  end
end
