class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.references :track
      t.references :story
      t.integer :start_min
      t.integer :end_min
      t.integer :user_id, index: true
      t.integer :identified_by, index: true
      t.timestamps
    end
  end
end
