class Artist < ActiveRecord::Base
  attr_accessible :name
  has_many :tracks, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true

  def self.search(query)
    if query && query.length > 0
      Artist.includes(:tracks).where("artists.name ILIKE ?", "#{query}%").order("artists.name")
    else
      Artist.includes(:tracks).order("artists.name")
    end
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
