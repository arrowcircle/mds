# coding:utf-8
module Movable
  def move
    if user_signed_in? && current_user.can_destroy?
      get_parent_and_children
      if new_parent
        update_child
        render "move_form"
      else
        render "move_form"
      end
    else
      render "move_form"
    end
  end

  private

    def new_parent
      case self.class.name
        when "StoriesController" then @new_author
        when "TracksController" then @new_artist
      end
    end

    def get_parent_and_children
      case self.class.name
        when "StoriesController"
          @story = @author.stories.find(params[:id])
          @new_author = Author.where(id: params[:new_author_id]).try(:first)
        when "TracksController"
          @track = @artist.tracks.find(params[:id])
          @new_artist = Artist.where(id: params[:new_artist_id]).try(:first)
      end
    end

    def update_child
      case self.class.name
        when "StoriesController" then @story.update_attributes(author_id: @new_author.id)
        when "TracksController" then @track.update_attributes(artist_id: @new_artist.id)
      end
    end
end