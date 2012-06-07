class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :story_id
      t.string :link

      t.timestamps
    end
    add_index :links, :story_id
  end
end
