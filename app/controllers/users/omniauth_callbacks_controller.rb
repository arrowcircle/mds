#coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def facebook
    omniauth_with_provider(:facebook)
  end

  def twitter
    omniauth_with_provider(:twitter)
  end

  def vkontakte
    omniauth_with_provider(:vkontakte)
  end

  private

    def find_user_for_provider provider
      case provider
        when :vkontakte then User.find_for_vkontakte_oauth(request.env["omniauth.auth"], current_user)
        when :facebook then User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
        when :twitter then User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
      end
    end

    def omniauth_with_provider provider
      @user = find_user_for_provider(provider)
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider.capitalize
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
end