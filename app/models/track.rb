class Track < ApplicationRecord
  include Sluggable
  extend Searchable
  include ImageUploader::Attachment(:image)
  validates :name, presence: true
  normalizes :name, with: -> { _1.strip }

  belongs_to :artist, counter_cache: true
  has_many :playlists, dependent: :destroy
  has_many :stories, through: :playlists
end
