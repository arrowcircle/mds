class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.search(params[:q]))
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Спасибо за регистрацию', status: :see_other
    else
      render "new", status: :unprocessable_entity
    end
  end

  private
    def title
      return 'Участиники проекта' if action_name == 'index'
      "#{@user.username} | Участиники проекта"
    end

    def description
      return 'Список всех участиников проекта' if action_name == 'index'
      "#{@user.username} | Страница участника проекта"
    end

    def tags
      'Участники, модель для сборки, список пользователей'
    end
end
