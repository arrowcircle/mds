class AddFullToStory < ActiveRecord::Migration
  def change
    add_column :stories, :full, :boolean, :default => false
  end
end
