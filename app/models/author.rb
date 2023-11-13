class Author < ApplicationRecord
  include Sluggable
  extend Searchable
  include ImageUploader::Attachment(:image)
  validates :name, presence: true
  normalizes :name, with: -> { _1.strip }
  has_many :stories, dependent: :destroy
end
