class Story < ApplicationRecord
  extend Searchable
  include Sluggable
  belongs_to :author, counter_cache: true

  validates :name, presence: true
end
