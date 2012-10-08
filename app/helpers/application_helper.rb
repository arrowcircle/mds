module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => :del)
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end

  def user_avatar_link user
    if user.avatar.url
      link_to image_tag(user.avatar.url, :size => "32x32", :alt => user.username), user
    else
      link_to image_tag("no_avatar.png", :size => "32x32", :alt => user.username), user
    end
  end
end
