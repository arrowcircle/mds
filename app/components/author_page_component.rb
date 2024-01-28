class AuthorPageComponent < ViewComponent::Base
  attr_reader :author, :stories, :current_user

  def initialize(author:, pagy:, stories: [], query: nil, page: nil, current_user: NullUser.new)
    @author = author
    @stories = stories
    @pagy = pagy
    @query = query
    @page = page
    @current_user = current_user
  end

  def buttons
    buttons = []
    buttons << PageTitleButtonComponent.new(title: "Добавить рассказ", icon: "images/add.svg", link: [:new, author, :story], mobile_visible: false) if current_user.id.present?
    buttons << PageTitleButtonComponent.new(title: "Редактировать", icon: "images/edit.svg", link: [:edit, author], mobile_visible: false) if current_user.admin?
    buttons << PageTitleButtonComponent.new(title: "назад", icon: "images/arrow_left.svg", link: :back, mobile_visible: true)
  end

  def title
    author.name
  end

  def metadata
    return ["Всего: #{@pagy.count}"] if @pagy.count > 0

    []
  end
end
