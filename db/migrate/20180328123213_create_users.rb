# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.text :avatar_data
      t.string :username, null: false
      t.integer :role, default: 0
      t.integer :playlists_count, default: 0
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
