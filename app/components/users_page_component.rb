class UsersPageComponent < ViewComponent::Base
  attr_reader :current_user
  include Pagy::Frontend
  def initialize(users:, pagy:, query: nil, page: nil, current_user: nil)
    @users = users
    @pagy = pagy
    @query = query
    @page = page
    @current_user = current_user
  end

  def buttons
    []
  end

  def title
    return "Участники проекта" if @users.present?
    "Мы не нашли такого пользователя"
  end

  def metadata
    return ["Всего: #{@pagy.count}"] if @pagy.count > 0
    []
  end
end
