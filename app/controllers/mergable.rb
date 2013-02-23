# coding:utf-8
module Mergable
  def merge
    if user_signed_in? && current_user.can_destroy?
      old_and_new_parent
      if @new_parent
        render "merge_form"
      else
        render "merge_form"
      end
    else
      render "merge_form"
    end
  end

  private

    def old_and_new_parent
      case self.class.name
        when "AuthorsController" then @parent = Author.find(params[:id])
        when "ArtistsController" then @parent = Artist.find(params[:id])
      end
      @new_parent = @parent.merge(params[parent_symbol])
    end

    def parent_symbol
      case self.class.name
        when "AuthorsController" then :author_id
        when "ArtistsController" then :artist_id
      end
    end

end