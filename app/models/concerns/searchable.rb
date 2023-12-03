module Searchable
  extend ActiveSupport::Concern
  def search(query, default_scope = nil)
    scope = default_scope
    scope ||= all
    return scope unless query && query.length > 0
    scope.where(self.arel_table[:name].lower.matches("#{query.downcase}%"))
  end
end
