#coding: utf-8
class MainController < ApplicationController
  def index
  end

  def login
  end

  def unparsed
    @stories = Story.where(parsed: false).where("(updated_at > last_fetched_at) and last_fetched_at is not null").page(params[:page])
  end

  def update_password
    @user = User.find(current_user.id)
    if !params[:password].present?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path, :notice => "Профиль изменен"
    else
      redirect_to edit_user_registration_path, :alert => @user.errors.full_messages.join("; ")
    end
  end

  def search
    if params[:search].present?
      @authors = Author.search(params[:search])
      @stories = Story.search(params[:search])
      @artists = Artist.search(params[:search])
      @tracks = Track.search(params[:search])
    else
    end
  end

end