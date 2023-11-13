# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Passwordless::ControllerHelpers

  private

  def current_user
    @current_user ||= authenticate_by_session(User) || NullUser.new
  end
  helper_method :current_user

  def authenticate_user!
    return true if current_user.id.present?
    redirect_to root_url, alert: "Нужно залогиниться", status: :see_other
  end

  def authenticate_admin!
    return true if current_user.admin?
    redirect_to root_url, alert: "Только для админов", status: :see_other
  end

  def metadata
    @metadata ||= OpenStruct.new(title: title, description: description, og: og)
  end
  helper_method :metadata

  def og
    {}
  end

  def title
    "Проект с плейлистами из радиопередачи модель для сборки"
  end
  helper_method :title

  def description
    "Мы собираем плейлисты из рассказов, которые игрались в эфире передачи модель для сборки"
  end
  helper_method :description

  def tags
    "Модель для сборки, что играет, опознать трек, мдс"
  end
  helper_method :tags
end
