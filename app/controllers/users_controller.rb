class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.search(params[:search]))
  end

  def show
    @user = User.find(params[:id])
  end
end
