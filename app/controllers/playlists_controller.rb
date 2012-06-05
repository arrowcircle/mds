#coding: utf-8
class PlaylistsController < ApplicationController
  before_filter :get_res

  def new
    @playlist = @story.playlists.build
    render "form"
  end

  def edit
    @playlist = @story.playlists.find(params[:id])
    render "form"
  end

  def create
    @playlist = @story.playlists.build(params[:playlist])
    @playlist.assign_author_and_track params
    if @playlist.save
      redirect_to [@author, @story], notice: "Трек добавлен"
    else
      redirect_to [@author, @story], alert: "Ошибка добавления трека"
    end
  end

  def update
    @playlist = @story.playlists.find(params[:id])

    @playlist.assign_author_and_track params
    if @playlist.update_attributes(params[:playlist])
      redirect_to [@author, @story], notice: "Трек отредактирован"
    else
      redirect_to [@author, @story], alert: "Ошибка редактирования трека"
    end
  end

  private
  def get_res
    @author = Author.find(params[:author_id])
    if @author
      @story = @author.stories.find(params[:story_id])
    end
    redirect_to root_path, alert: "Автор или рассказ не найден. Скорее всего, вы перешли по неверной ссылке. Попробуйте поиск" if @story.nil?
  end
end