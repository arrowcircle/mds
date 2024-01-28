class PlaylistItemComponent < ViewComponent::Base
  attr_reader :playlist, :current_user

  def initialize(item:, current_user:)
    @playlist = item
    @current_user = current_user
  end

  def self.headers
    ["Название", "Время", "Слушать", ""]
  end

  def author
    story.author
  end

  def story
    playlist.story
  end
end
