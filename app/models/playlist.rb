class Playlist < ApplicationRecord
  belongs_to :story, counter_cache: true
  belongs_to :track, optional: true, counter_cache: true
  belongs_to :identifier, class_name: "User", foreign_key: "identified_by", optional: true
  belongs_to :user, optional: true

  attr_accessor :request, :artist_name, :track_name
  before_save :create_artist_and_track

  scope :requests, -> { where(track_id: nil) }
  scope :identified, -> { where.not(track_id: nil) }

  def set_names
    return true unless track.present?
    @track_name = track.name
    @artist_name = track.artist.name
  end

  def create_artist_and_track
    return unless artist_name.present?
    return unless track_name.present?
    a = Artist.search(artist_name).first
    a ||= Artist.new(name: artist_name)
    a.save
    t = Track.search(track_name, a.tracks).first
    t ||= a.tracks.build(name: track_name, artist: a)
    t.save
    self.track_id = t.id
  end
end
