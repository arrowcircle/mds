class AddFullToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :full, :boolean, :default => false
  end

  def self.down
    remove_column :stories, :full
  end
end
