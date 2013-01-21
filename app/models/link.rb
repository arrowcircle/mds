class Link < ActiveRecord::Base
  attr_accessible :link, :story_id
  belongs_to :story
  validates :link, :presence => true
  validates :story_id, :presence => true
end
