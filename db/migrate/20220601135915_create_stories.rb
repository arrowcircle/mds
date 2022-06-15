class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :description
      t.text :image_data
      t.boolean :completed
      t.date :date
      t.integer :radio
      t.jsonb :json_field, default: {}
      t.integer :playlists_count, default: 0

      t.references :author
      t.timestamps
    end
  end
end
