class AddLastFetchedAtToStory < ActiveRecord::Migration
  def change
    add_column :stories, :last_fetched_at, :datetime
  end
end
