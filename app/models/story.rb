class Story < ApplicationRecord
  extend Searchable
  include Sluggable
  include ImageUploader::Attachment(:image)
  belongs_to :author, counter_cache: true
  has_many :playlists, dependent: :destroy
  store_attribute :json_field, :external_audio_url, :string

  validates :name, presence: true
  normalizes :name, with: -> { _1.strip }

  enum radio: {
    station: 0,
    muztv: 1,
    silver_rain: 2,
    energy: 3,
    pioneer: 4,
    live: 5,
    podcast: 6,
    station_1068: 7,
    nrg: 8
  }
end
