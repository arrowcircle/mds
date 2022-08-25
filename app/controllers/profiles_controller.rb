class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
  end

  def update
    if current_user.update(user_attributes)
      redirect_to root_path, notice: "Профиль обновлен", status: :see_other
    else
      render "show", status: :unprocessable_entity
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:username, :avatar)
  end
end
