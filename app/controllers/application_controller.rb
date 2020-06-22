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
end
