class Story < ActiveRecord::Base
  include Story::Fetcher
  include Searchable
  include Parametrizer
  belongs_to :author
  has_many :playlists, :order => :startmin, :dependent => :destroy
  has_many :links, :dependent => :destroy
  acts_as_taggable_on :tags

  accepts_nested_attributes_for :links, :allow_destroy => true

  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio, :links_attributes, :tag_list, :fetcher_comment, :last_fetched_at, :parsed

  validates :name, :presence =>  true

  def full_name
    author.name+" - " + name
  end

end
