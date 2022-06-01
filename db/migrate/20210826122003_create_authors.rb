class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.text :image_data

      t.timestamps
    end
  end
end
