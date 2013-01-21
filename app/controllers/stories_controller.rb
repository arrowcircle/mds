#coding: utf-8
class StoriesController < ApplicationController
  before_filter :get_author, :filter_params
  before_filter :check_edit_access, only: [:edit, :update]

  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag'

  def move_form
    @story = @author.stories.find(params[:id])
  end

  def move
    @story = @author.stories.find(params[:id])
    @new_author = Author.where(id: params[:new_author_id]).try(:first)
    if @new_author
      @story.update_attributes(author_id: @new_author.id)
      render "move_form"
    else
      render "move_form"
    end
  end

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
      render "create"
    else
      render "form"
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = @author.stories.find(params[:id])
    if current_user && current_user.role >= 1
      if @story.update_attributes(params[:story])
        render "create"
      else
        render "edit"
      end
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

  def filter_params
    if params && params[:story] && params[:story][:tag_list]
      params[:story][:tag_list] = params[:story][:tag_list].downcase
    end
  end

end
