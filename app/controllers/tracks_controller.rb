class TracksController < ApplicationController
  before_action :set_artist
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_admin!, only: [:edit, :update, :destroy]
  def search
    @tracks = Track.search(params[:q], @artist.tracks).order(:name).limit(10)
    render "search", layout: false
  end

  def index
    redirect_to [@artist], status: :moved_permanently
  end

  def show
    @track = @artist.tracks.find(params[:id])
    @stories = @track.stories.includes(:author).order("authors.name")
  end

  def new
    @track = @artist.tracks.build
    render "edit"
  end

  def create
    @track = @artist.tracks.build(track_params)
    if @track.save
      redirect_to [@artist, @track], status: :see_other, notice: "Трек добавлен"
    else
      render "edit", status: :unprocessable_content
    end
  end

  def edit
    @track = @artist.tracks.find(params[:id])
  end

  def update
    @track = @artist.tracks.find(params[:id])
    if @track.update(track_params)
      redirect_to [@artist, @track], status: :see_other, notice: "Трек обновлен"
    else
      render "edit", status: :unprocessable_content
    end
  end

  private

  def title
    return "#{@track.name} - #{@artist.name}" if @track && @artist
    return @artist.name if @artist

    super
  end

  def description
    if @track && @artist
      return "#{@artist.name} - #{@track.name}: рассказы радиопередачи Модель для Сборки, где звучит этот трек"
    end

    return "Треки #{@artist.name}, звучавшие в рассказах радиопередачи Модель для Сборки" if @artist

    super
  end

  def tags
    base = "мдс, модель для сборки, что играет, опознать трек, музыка, помощь в опознании, плейлист, список треков"
    return "#{base}, #{@artist.name}, #{@track.name}" if @track && @artist
    return "#{base}, исполнитель, #{@artist.name}" if @artist

    super
  end

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  def track_params
    params.require(:track).permit(:name, :description, :image)
  end
end
