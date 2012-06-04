class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :story_id
      t.integer :startmin
      t.integer :endmin
      t.integer :track_id
      t.integer :user_id
      t.integer :identified_by

      t.timestamps
    end
    add_index :playlists, :story_id
    add_index :playlists, :track_id
    add_index :playlists, :user_id
    add_index :playlists, :identified_by
  end
end
