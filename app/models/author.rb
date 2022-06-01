class Author < ApplicationRecord
  include Sluggable
  extend Searchable
  validates :name, presence: true, uniqueness: true
  include ImageUploader::Attachment(:image)
end
