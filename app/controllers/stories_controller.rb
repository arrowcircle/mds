#coding: utf-8
class StoriesController < ApplicationController
  before_filter :get_author
  before_filter :check_edit_access, only: [:edit, :update]
  # GET /stories
  # GET /stories.json
  def index
    @stories = @author.stories.order(:name).page(params[:page]).per(20)
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story =  @author.stories.includes(:playlists).find(params[:id])
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = @author.stories.build
    render "form"
  end

  # GET /stories/1/edit
  def edit
    @story = @author.stories.find(params[:id])
    render "form"
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = @author.stories.build(params[:story])
    if @story.save
      redirect_to [@autor, @story], notice: 'Рассказ добавлен'
    else
      render action: "new"
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = @author.stories.find(params[:id])
    if @story.update_attributes(params[:story])
      redirect_to [@author, @story], notice: 'Story was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    if user_signed_in? && current_user.role > 1
      @story = @author.stories.find(params[:id])
      @story.destroy
      redirect_to author_stories_path(@author), alert: "Рассказ удален"
    else
      redirect_to :back, alert: "У Вас недостаточно прав для удаления"
    end
  end

  private

  def get_author
    @author = Author.find(params[:author_id])
    redirect_to root_url if @author.nil?
  end

  def check_edit_access
    if user_signed_in?
      if current_user.role < 1
        redirect_to :back, alert: "У Вас недостаточно прав для редактирования"
      end
    else
      redirect_to :back, alert: "У Вас недостаточно прав для редактирования"
    end
  end

end
