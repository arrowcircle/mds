class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.text :image_data
      t.integer :stories_count, default: 0

      t.timestamps
    end
  end
end
