class AddFieldsToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :completed, :boolean, :default => false
    add_column :stories, :link, :string
  end

  def self.down
    remove_column :stories, :link
    remove_column :stories, :completed
  end
end
