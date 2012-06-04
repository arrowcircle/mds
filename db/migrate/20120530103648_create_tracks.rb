class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :artist_id

      t.timestamps
    end
    add_index :tracks, :artist_id
  end
end
