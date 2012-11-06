#coding: utf-8
module StoriesHelper

  def show_download_link story
  end

  def show_tags story
    res = ""
    story.tags.collect do |tag|
      res << link_to(tag.name, tag_path(tag.name), :class => "btn btn-mini btn-info")
    end
    raw res
  end

  def story_show_radio radio
    "Радио: " +
    case radio
    when 0 then "Станция 2000"
    when 1 then "Муз ТВ"
    when 2 then "Серебряный дождь"
    when 3 then "Энергия"
    when 4 then "Пионер ФМ"
    when 5 then "Лайв"
    when 6 then "Подкаст"
    when 7 then "Станцию 106.8"
    else "Не указано"
    end
  end

  def story_show_date date
    res = "Дата эфира: "
    date.nil? ? res += "не указана" : res += I18n.l(date, :format => "%d %b, %Y")
    res
  end

  def story_form_header story
    if story.new_record?
      "Добавить рассказ"
    else
      "Редактировать рассказ"
    end
  end

  def story_submit_text story
    if story.new_record?
      "Добавить"
    else
      "Сохранить"
    end
  end

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
    link_to name, [story.author, story]
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
    case story.try(:radio)
      when 0 then "Станция 2000"
      when 1 then "Муз ТВ"
      when 2 then "Серебряный дождь"
      when 3 then "Энергия"
      when 4 then "Пионер ФМ"
      else ""
    end
  end
end
