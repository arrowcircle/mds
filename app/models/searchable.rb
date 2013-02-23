# coding: utf-8
module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search_table_name
      self.table_name
    end

    def includes_symbol
      case self.class.name
        when "Artist" then :tracks
        when "Author" then :stories
        when "Story" then nil
        when "Track" then nil
      end
    end

    def search(query)
      s = self.scoped
      s = s.includes(includes_symbol) if includes_symbol
      s = s.where("#{search_table_name}.name ILIKE ?", "#{query}%") if query && query.length > 0
      s.order("#{search_table_name}.name")
    end
  end
end