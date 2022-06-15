class Author < ApplicationRecord
  include Sluggable
  extend Searchable
  include ImageUploader::Attachment(:image)
  validates :name, presence: true, uniqueness: true
  has_many :stories, dependent: :destroy
end
