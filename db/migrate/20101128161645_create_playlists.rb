class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.integer :track_id
      t.integer :story_id
      t.integer :startmin
      t.integer :endmin

      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end
