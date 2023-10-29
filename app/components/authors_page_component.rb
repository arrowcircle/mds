class AuthorsPageComponent < ViewComponent::Base
  attr_reader :current_user
  include Pagy::Frontend
  def initialize(authors:, pagy:, query: nil, page: nil, current_user: nil)
    @authors = authors
    @pagy = pagy
    @query = query
    @page = page
    @current_user = current_user
  end

  def buttons
    [
      PageTitleButtonComponent.new(title: "Добавить", icon: "images/add.svg", link: [:new, :author], mobile_visible: true)
    ]
  end

  def title
    return "Авторы" if @authors.present?
    "Мы не нашли такого автора"
  end

  def metadata
    return ["Всего: #{@pagy.count}"] if @pagy.count > 0
    []
  end
end
