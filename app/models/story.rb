class Story < ActiveRecord::Base
  belongs_to :author
  has_many :playlists, :order => :startmin, :dependent => :destroy
  has_many :links, :dependent => :destroy

  accepts_nested_attributes_for :links, :allow_destroy => true

  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio, :links_attributes
  
  validates :name, :presence =>  true

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
