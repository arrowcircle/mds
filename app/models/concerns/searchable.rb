module Searchable
  extend ActiveSupport::Concern
  def search(query)
    return all unless query && query.length > 0
    where('name ILIKE ?', "%#{query}%")
  end
end