class Track < ActiveRecord::Base
  include Searchable
  include Parametrizer
  attr_accessible :artist_id, :name
  belongs_to :artist
  has_many :playlists, :dependent => :destroy
  has_many :stories, :through => :playlists

  def full_name
    "#{artist.name} - #{name}"
  end
end
