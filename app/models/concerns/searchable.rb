module Searchable
  extend ActiveSupport::Concern
  def search(query, default_scope = nil)
    scope = default_scope
    scope ||= all
    return scope unless query && query.length > 0
    scope.where("name ILIKE ?", "%#{query}%")
  end
end
