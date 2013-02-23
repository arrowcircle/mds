#coding: utf-8
class TracksController < ApplicationController
  include Movable
  before_filter :get_artist

  def move_form
    @track = @artist.tracks.find(params[:id])
  end

  def search
    @tracks = @artist.tracks.search params[:term]
    render :json => @tracks.map(&:name)
  end

  def index
    @tracks = @artist.tracks
  end

  def new
    @track = @artist.tracks.build
    render "form"
  end

  def edit
    @track = @artist.tracks.find(params[:id])
    render "form"
  end

  def create
    @track = @artist.tracks.build(params[:track])
    if @track.save
      render "create"
    else
      render "form"
    end
  end

  def show
    @track = @artist.tracks.find(params[:id])
  end

  def update
    @track = @artist.tracks.find(params[:id])
    if @track.update_attributes(params[:track])
      render "create"
    else
      render "edit"
    end
  end

  def destroy
    if user_signed_in? && current_user.role > 1
      @track = @artist.tracks.find(params[:id])
      @track.destroy
      redirect_to artist_tracks_path(@artist), alert: "Рассказ удален"
    else
      redirect_to :back, alert: "У Вас недостаточно прав для удаления"
    end
  end

  private
  def get_artist
    @artist = Artist.find(params[:artist_id])
  end
end