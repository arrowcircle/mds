class StoriesController < ApplicationController
  before_action :set_author
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_admin!, only: [:edit, :update, :destroy]
  def show
    @story = @author.stories.find(params[:id])
    @playlists = @story.playlists.includes(:identifier, track: :artist).order(:start_min)
  end

  def new
    @story = @author.stories.build
    render "edit"
  end

  def create
    @story = @author.stories.build(story_params)
    if @story.save
      redirect_to [@author, @story], status: :see_other, notice: "Рассказ добавлен"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def edit
    @story = @author.stories.find(params[:id])
  end

  def update
    @story = @author.stories.find(params[:id])
    if @story.update(story_params)
      redirect_to [@author, @story], status: :see_other, notice: "Рассказ обновлен"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def set_author
    @author = Author.find(params[:author_id])
  end

  def story_params
    params.require(:story).permit(:name, :description, :image, :completed)
  end
end
