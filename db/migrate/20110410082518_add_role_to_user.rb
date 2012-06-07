class AddRoleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :integer, :default => 0
    remove_column :users, :password_salt
  end

  def self.down
    remove_column :users, :role
    add_column :users, :password_salt, :string
  end
end
