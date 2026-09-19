class AuthorsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_admin!, only: [:edit, :update, :destroy]
  def index
    scope = Author.search(params[:q])
    scope = scope.order(:name)
    @pagy, @authors = pagy(scope)
  end

  def show
    @author = Author.find(params[:id])
    @pagy, @stories = pagy(Story.search(params[:q], @author.stories.order(:name)))
  end

  def new
    @author = Author.new
    render "edit"
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to [@author], notice: "Автор добавлен", status: :see_other
    else
      render "edit", status: :unprocessable_content
    end
  end

  def edit
    @author = Author.find(params[:id])
  end

  def update
    @author = Author.find(params[:id])
    if @author.update(author_params)
      redirect_to [@author], notice: "Автор обновлен", status: :see_other
    else
      render "edit", status: :unprocessable_content
    end
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    redirect_to [:authors], notice: "Автор удален", status: :see_other
  end

  private

  def title
    return "Авторы" if action_name == "index"
    @author&.name.presence || "Добавить автора"
  end

  def description
    if action_name == "index"
      return "Страница со списком авторов рассказов игравших в радиопередаче Модель Для Сборки"
    end

    return "Рассказы #{@author.name} и музыка из них в радиопередаче Модель для Сборки" if @author

    super
  end

  def tags
    base = "мдс, модель для сборки, что играет, опознать трек, музыка, помощь в опознании, плейлист, список треков, музыка из рассказа"
    return "#{base}, список авторов" if action_name == "index"
    return "#{base}, #{@author.name}" if @author

    super
  end

  def author_params
    params.require(:author).permit(:name, :description, :image)
  end
end
