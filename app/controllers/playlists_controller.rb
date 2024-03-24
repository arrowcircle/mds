class PlaylistsController < ApplicationController
  before_action :set_author_and_story
  before_action :authenticate_user!, only: %i[new create]
  before_action :authenticate_admin!, only: %i[edit update destroy]

  def new
    @playlist = @story.playlists.build(playlist_params)
    @playlist.set_names
    render "edit"
  end

  def create
    @playlist = @story.playlists.build(playlist_params)
    @playlist.set_names
    @playlist.identifier ||= current_user if current_user.id.present?
    if @playlist.save
      redirect_to [@author, @story], status: :see_other, notice: "Трек добавлен"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def edit
    @playlist = @story.playlists.find(params[:id])
    @playlist.set_names
  end

  def update
    @playlist = @story.playlists.find(params[:id])
    @playlist.set_names
    @playlist.identifier ||= current_user if current_user.id.present?
    if @playlist.update(playlist_params)
      redirect_to [@author, @story], status: :see_other, notice: "Трек обновлен"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to [@author, @story], status: :unprocessable_entity, alert: "Только админы могут удалять опознания" unless current_user.admin?

    @playlist = @story.playlists.find(params[:id])
    if @playlist.destroy
      redirect_to [@author, @story], status: :see_other, notice: "Трек удален"
    else
      redirect_to [@author, @story], status: :unprocessable_entity, alert: "Ошибки: #{@playlist.errors.map(&:full_messages)}"
    end
  end

  private

  def set_author_and_story
    @author = Author.find(params[:author_id])
    @story = @author.stories.find(params[:story_id])
  end

  def playlist_params
    attrs = %i[track_id start_min end_min request artist_name track_name artist_id]
    attrs << [:identified_by] if current_user.admin?
    params.require(:playlist).permit(attrs)
  rescue StandardError
    {}
  end
end
