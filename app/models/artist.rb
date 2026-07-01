class Artist < ApplicationRecord
  include Sluggable
  extend Searchable
  include ImageUploader::Attachment(:image)

  validates :name, presence: true
  normalizes :name, with: -> { it.strip }
  has_many :tracks, dependent: :destroy
end
