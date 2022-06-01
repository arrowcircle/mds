class Story < ApplicationRecord
  extend Searchable
  include Sluggable
  include ImageUploader::Attachment(:image)
  belongs_to :author, counter_cache: true

  validates :name, presence: true
end
