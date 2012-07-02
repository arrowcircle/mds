class Story < ActiveRecord::Base
  belongs_to :author
  has_many :playlists, :order => :startmin, :dependent => :destroy
  has_many :links, :dependent => :destroy
  acts_as_taggable_on :tags

  accepts_nested_attributes_for :links, :allow_destroy => true

  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio, :links_attributes, :tag_list
  
  validates :name, :presence =>  true

  def full_name
    author.name+" - " + name
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
