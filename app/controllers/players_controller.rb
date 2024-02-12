class PlayersController < ApplicationController
  def create
    if item.playable_audio_url.present?
      session[:playing] = "#{item.class.name}:#{item.id}"
      session[:play_position] = 0
      @autoplay = true
    else
      redirect_to play_redirect_path, status: :unprocessable_entity, alert: "У этого рассказа нет аудио для прослушивания"
    end
  end

  def update
    if session[:playing].present?
      position = params.dig(:play, :position)
      session[:play_position] = position if position
    end
    head :ok
  end

  def destroy
    session.delete(:playing)
  end

  private

  def play_redirect_path
    return root_path unless item
    return [item.author, item] if item.is_a?(Story)
    return [item.artist, item] if item.is_a?(Track)

    root_path
  end

  def item
    @item ||= fetch_item
  end

  def fetch_item
    return play_item unless params[:play].present?

    klass, id = params[:play].split(":")
    klass.constantize.find_by(id:) || play_item
  rescue StandardError
    nil
  end
end
