class Author < ApplicationRecord
  include Sluggable
  validates :name, presence: true, uniqueness: true
end
