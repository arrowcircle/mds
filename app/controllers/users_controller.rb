#coding: utf-8
class UsersController < ApplicationController
  def index
    @users = User.search(params[:search]).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
  end
end