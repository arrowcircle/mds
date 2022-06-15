class Artist < ApplicationRecord
  include Sluggable
  extend Searchable
  include ImageUploader::Attachment(:image)
  validates :name, presence: true, uniqueness: true
  has_many :tracks, dependent: :destroy
end
