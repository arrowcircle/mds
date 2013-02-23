class Artist < ActiveRecord::Base
  include Searchable
  attr_accessible :name
  has_many :tracks, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true

  def merge(artist_id)
    artist = Artist.where(id: artist_id).try(:first)
    if artist
      tracks.update_all(artist_id: artist_id)
      self.destroy
      artist
    else
      false
    end
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
