class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.text :description
      t.text :image_data
      t.references :artist
      t.integer :playlists_count, default: 0
      t.timestamps
    end
  end
end
