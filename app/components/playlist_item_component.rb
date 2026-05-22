class PlaylistItemComponent < ViewComponent::Base
  attr_reader :playlist, :current_user, :mobile

  def initialize(item:, current_user:, mobile: false)
    @playlist = item
    @current_user = current_user
    @mobile = mobile
  end

  def self.headers
    ["Название", "Время", "Слушать", ""]
  end

  def self.mobile_layout?
    true
  end

  def mobile?
    mobile
  end

  def time_label
    return "Не указано" unless playlist.start_min || playlist.end_min

    [playlist.start_min && "с #{playlist.start_min}", playlist.end_min && "по #{playlist.end_min}"].compact.join(" ")
  end

  def main_page?
    controller_name == "welcome"
  end

  def author
    story.author
  end

  def story
    playlist.story
  end
end
