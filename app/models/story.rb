class Story < ActiveRecord::Base
  belongs_to :author
  has_many :playlists, :order => :startmin, :dependent => :destroy
  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio
  validates :name, :presence =>  true

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
