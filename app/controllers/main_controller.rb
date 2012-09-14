#coding: utf-8
class MainController < ApplicationController
  def index
  end

  def login
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path, :notice => "Пароль изменен"
    else
      redirect_to edit_user_registration_path, :alert => "Ошибка изменения профиля"
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