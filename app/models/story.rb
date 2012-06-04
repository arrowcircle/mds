class Story < ActiveRecord::Base
  belongs_to :author, :dependent => :destroy
  has_many :playlists, :order => :startmin, :dependent => :destroy
  attr_accessible :author_id, :completed, :date, :link, :name, :position, :radio

  def to_param
    n = Russian.translit(self.name)
    slug = n.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    "#{id}-#{slug}"
  end
end
