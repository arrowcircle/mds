class Story < ActiveRecord::Base
  include Story::Fetcher
  belongs_to :author
  has_many :playlists, :order => :startmin, :dependent => :destroy
  has_many :links, :dependent => :destroy
  acts_as_taggable_on :tags

  accepts_nested_attributes_for :links, :allow_destroy => true

  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio, :links_attributes, :tag_list, :fetcher_comment, :last_fetched_at, :parsed

  validates :name, :presence =>  true

  def self.search(query)
    if query && query.length > 0
      Story.where("name ILIKE ?", "%#{query}%").order("name")
    else
      Story.order("authors.name")
    end
  end

  def full_name
    author.name+" - " + name
  end

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
