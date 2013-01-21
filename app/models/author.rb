class Author < ActiveRecord::Base
  attr_accessible :name
  has_many :stories
  validates :name, :presence => true

  def self.search(query)
    if query && query.length > 0
      Author.includes(:stories).where("authors.name ILIKE ?", "%#{query}%").order("authors.name")
    else
      Author.includes(:stories).order("authors.name")
    end
  end

  def merge(author_id)
    author = Author.where(id: author_id).try(:first)
    if author
      stories.update_all(author_id: author_id)
      self.destroy
      author
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
