class ChangeStories < ActiveRecord::Migration
  def change
    add_column :stories, :date, :date
    add_column :stories, :radio, :integer
  end
end
