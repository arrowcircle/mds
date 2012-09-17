#coding: utf-8
class PlaylistsController < ApplicationController
  before_filter :get_res, :except => :index

  def index
    if user_signed_in?
      @requests = Playlist.where(user_id: current_user.id, track_id: nil).order("created_at DESC").page(params[:page]).per(20)
      @playlists = Playlist.where(user_id: current_user.id).where("track_id is not null").order("updated_at DESC").page(params[:page]).per(20)
    else
      redirect_to root_path, alert: "Необходимо войти в систему"
    end
  end

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

  def destroy
    @playlist = @story.playlists.find(params[:id])
    if current_user.role >= 1
      @playlist.destroy
      redirect_to [@author, @story], :alert => "Трек удален"
    else
      redirect_to [@author, @story], :alert => "Недостаточно прав"
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