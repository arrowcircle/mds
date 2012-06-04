class Playlist < ActiveRecord::Base
  attr_accessible :endmin, :identified_by, :startmin, :story_id, :track_id, :user_id
  belongs_to :story, :dependent => :destroy
  belongs_to :track, :dependent => :destroy
  belongs_to :identifier, class_name: "User", foreign_key: "identified_by"
end
