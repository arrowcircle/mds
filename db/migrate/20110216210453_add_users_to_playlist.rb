class AddUsersToPlaylist < ActiveRecord::Migration
  def self.up
    add_column :playlists, :user_id, :integer
    add_column :playlists, :identified_by, :integer
  end

  def self.down
    remove_column :playlists, :identified_by
    remove_column :playlists, :user_id
  end
end
