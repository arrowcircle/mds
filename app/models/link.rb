class Link < ActiveRecord::Base
  attr_accessible :link, :story_id
  belongs_to :story
end
