#coding: utf-8
module StoriesHelper

  def story_header_link story
    raw "#{link_to @author.name, [@author, :stories]}
    - #{@story.name}"
  end

  def link_to_story(story)
    name = story.name+" ("
    if story.completed
      name += "полностью)"
    else
      name += "#{story.playlists.count})"
    end
    link_to name, [@author, story]
  end

  def can_edit?
    if user_signed_in?
      if current_user.role > 0
        true
      else
        false
      end
    else
      false
    end
  end

  def can_destroy?
    if user_signed_in?
      if current_user.role > 1
        true
      else
        false
      end
    else
      false
    end
  end

  def show_radio(story)
    case story.radio
      when 0 then "Станция 2000"
      when 1 then "Муз ТВ"
      when 2 then "Серебряный дождь"
      when 3 then "Энергия"
      when 4 then "Пионер ФМ"
      else ""
    end
  end
end
