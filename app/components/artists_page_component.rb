class ArtistsPageComponent < ViewComponent::Base
  attr_reader :current_user
  def initialize(artists:, pagy:, query: nil, page: nil, current_user: nil)
    @artists = artists
    @pagy = pagy
    @query = query
    @page = page
    @current_user = current_user
  end

  def buttons
    [
      PageTitleButtonComponent.new(title: "Добавить", icon: "images/add.svg", link: [:new, :artist], mobile_visible: true)
    ]
  end

  def title
    return "Артисты" if @artists.present?
    "Мы не нашли такого артиста"
  end

  def metadata
    return ["Всего: #{@pagy.count}"] if @pagy.count > 0
    []
  end
end
