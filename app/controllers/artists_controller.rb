class ArtistsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_admin!, only: [:edit, :update, :destroy]
  def search
    @artists = Artist.search(params[:q]).order(:name).limit(10)
    render "search", layout: false
  end

  def index
    scope = Artist.search(params[:q])
    scope = scope.order(:name)
    @pagy, @artists = pagy(scope)
  end

  def show
    @artist = Artist.find(params[:id])
    @pagy, @tracks = pagy(Track.search(params[:q], @artist.tracks.order(:name)))
  end

  def new
    @artist = Artist.new
    render "edit"
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      redirect_to [@artist], notice: "Артист добавлен", status: :see_other
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])
    if @artist.update(artist_params)
      redirect_to [@artist], notice: "Артист обновлен", status: :see_other
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    redirect_to [:artist], notice: "Артист удален", status: :see_other
  end

  private

  def artist_params
    params.require(:author).permit(:name, :description, :image)
  end
end
