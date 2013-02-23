#coding: utf-8
class ArtistsController < ApplicationController
  include Mergable
  autocomplete :artist, :name, :extra_data => [:id]

  def merge_form
    @artist = Artist.find(params[:id])
  end

  def search
    @artists = Artist.search params[:term]
    render :json => @artists.select([:id, :name])
  end

  def index
    @artists = Artist.search(params[:search]).page(params[:page]).per(20)
    @artist = Artist.new
  end

  def show
    @artist = Artist.find(params[:id])
    if @artist
      redirect_to [@artist, :tracks]
    else
      redirect_to artists_path
    end
  end

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new
    render "form"
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
    render "form"
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(params[:artist])
    if @artist.save
      render "create"
    else
      render "form"
    end
  end

  # PUT /artists/1
  # PUT /artists/1.json
  def update
    @artist = Artist.find(params[:id])
    if @artist.update_attributes(params[:artist])
      render "create"
    else
      render "form"
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    redirect_to artists_url
  end
end