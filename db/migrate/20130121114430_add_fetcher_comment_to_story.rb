class AddFetcherCommentToStory < ActiveRecord::Migration
  def change
    add_column :stories, :fetcher_comment, :text
  end
end
