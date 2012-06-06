class Track < ActiveRecord::Base
  attr_accessible :artist_id, :name
  belongs_to :artist

  def self.search q
    res = []
    res = where("name ILIKE ?", "#{q}%").order(:name) if q && q.length >= 1
    res
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
