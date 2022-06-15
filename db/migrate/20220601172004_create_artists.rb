class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :description
      t.text :image_data
      t.integer :tracks_count, default: 0

      t.timestamps
    end
  end
end
