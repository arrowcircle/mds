class Artist < ActiveRecord::Base
  attr_accessible :name
  has_many :tracks, :dependent => :destroy

  def self.search q
    res = []
    res = Artist.where("name @@ ?", q).order(:name) if q && q.length >= 1
    res
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
