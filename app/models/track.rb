class Track < ActiveRecord::Base
  include Searchable
  attr_accessible :artist_id, :name
  belongs_to :artist
  has_many :playlists, :dependent => :destroy
  has_many :stories, :through => :playlists

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end

  def full_name
    "#{artist.name} - #{name}"
  end
end
