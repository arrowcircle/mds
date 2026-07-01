class WelcomeController < ApplicationController
  def index
    @pagy, @playlists = pagy(Playlist.includes(:user, :identifier, track: :artist, story: :author).order(updated_at: :desc))
  end

  def health_check
    # Rails.logger.silence do
    begin
      ActiveRecord::Base.connection
      User&.first
      Mds.redis.get("healthcheck")
      obj = {msg: "success", status_code: 200, status: "healthy"}
    rescue ActiveRecord::NoDatabaseError
      obj = {msg: "failure", status_code: 500, status: "unhealthy"}
    end
    respond_to do |format|
      format.html { render plain: obj[:msg], status: obj[:status_code], content_type: "text/plain" }
      format.json { render json: obj.except(:status_code), status: obj[:status_code] }
      format.any { render plain: obj[:msg], status: obj[:status_code], content_type: "text/plain" }
    end
    # end
  end

  private

  def title
    "Что играет?"
  end

  def description
    "Главная страница сайта по опознанию и поиску музыки из радиопередачи Модель для Сборки"
  end

  def tags
    "мдс, модель для сборки, что играет, опознать трек, музыка, помощь в опознании, плейлист, список треков, музыка из рассказа"
  end
end
