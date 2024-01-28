class StoryPageComponent < ViewComponent::Base
  attr_reader :author, :story, :playlists, :current_user

  def initialize(author:, playlists:, story:, current_user: nil)
    @author = author
    @playlists = playlists
    @story = story
    @current_user = current_user
  end

  def buttons
    res = []
    res << PageTitleButtonComponent.new(title: "Редактировать", icon: "images/edit.svg", link: [:edit, author, story], mobile_visible: true) if current_user&.admin?
    res << PageTitleButtonComponent.new(title: "Назад", icon: "images/arrow_left.svg", link: [author], mobile_visible: true)
  end

  def title
    res = []
    res << link_to(author.name, [author], class: :link)
    res << "-"
    res << story.name
    raw res.join(" ")
  end

  def metadata
    res = []
    res << "Дата эфира: #{l story.date, format: '%d %b, %Y'}" if story.date
    res << "Радио: #{Story.human_enum_name(:radio, @story.radio)}" if story.radio

    res
  end
end
