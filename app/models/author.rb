class Author < ActiveRecord::Base
  include Searchable
  include Parametrizer
  attr_accessible :name
  has_many :stories
  validates :name, :presence => true

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

end
