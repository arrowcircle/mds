class AddParsedToStory < ActiveRecord::Migration
  def change
    add_column :stories, :parsed, :boolean, :default => false
  end
end
