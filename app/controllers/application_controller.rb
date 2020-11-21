# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      keys = [:username, :email, :avatar]
      [:sign_up, :sign_in, :account_update].each do |key|
        devise_parameter_sanitizer.permit(key, keys: keys)
      end
    end

  private
    def metadata
      @metadata ||= OpenStruct.new(title: title, description: description, og: og)
    end
    helper_method :metadata

    def og
      {}
    end

    def title
      'Проект с плейлистами из радиопередачи модель для сборки'
    end
    helper_method :title

    def description
      'Мы собираем плейлисты из рассказов, которые игрались в эфире передачи модель для сборки'
    end
    helper_method :description

    def tags
      'Модель для сборки, что играет, опознать трек, мдс'
    end
    helper_method :tags
end
