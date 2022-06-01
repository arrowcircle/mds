class Story < ApplicationRecord
  enum radio: {
    station: 0,
    muztv: 1,
    silver_rain: 2,
    energy: 3,
    pioneer: 4,
    live: 5,
    podcast: 6,
    station_1068: 7
  }

  extend Searchable
  include Sluggable
  include ImageUploader::Attachment(:image)
  belongs_to :author, counter_cache: true

  validates :name, presence: true
end
