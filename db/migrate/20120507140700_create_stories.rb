class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :name
      t.date :date
      t.integer :position
      t.integer :radio
      t.integer :author_id
      t.boolean :completed
      t.string :link

      t.timestamps
    end
  end
end
