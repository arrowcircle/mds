#coding: utf-8
module AuthorsHelper
  def author_form_header author
    if author.new_record?
      "Добавить автора"
    else
      "Редактировать автора"
    end
  end

  def author_submit_text author
    if author.new_record?
      "Добавить"
    else
      "Сохранить"
    end
  end

end
