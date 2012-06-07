class AddRequestedToPlaylist < ActiveRecord::Migration
  def self.up
    add_column :playlists, :requested, :boolean, :default => true
  end

  def self.down
    remove_column :playlists, :requested
  end
end
