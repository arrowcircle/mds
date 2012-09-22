class Playlist < ActiveRecord::Base
  attr_accessible :endmin, :identified_by, :startmin, :story_id, :track_id, :user_id
  belongs_to :story
  belongs_to :track
  belongs_to :identifier, class_name: "User", foreign_key: "identified_by"

  scope :requests, where(track_id: nil)
  scope :identified, where("track_id is not null")

  def assign_author_and_track params
    artist_name, track_name = parse_params(params)
    if artist_name && track_name
      artist = Artist.find_or_create_by_name(artist_name)
      self.track_id = artist.tracks.find_or_create_by_name(track_name).id
    end
  end

  def parse_params params
    artist_name = params[:artist] if params[:artist].present?
    track_name = params[:track] if params[:track].present?
    if artist_name && track_name
      return artist_name, track_name
    else
      return false, false
    end
  end
end
