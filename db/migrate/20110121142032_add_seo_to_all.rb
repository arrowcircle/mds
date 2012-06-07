class AddSeoToAll < ActiveRecord::Migration
  def self.up
    add_column :authors, :seolink, :string
    add_column :stories, :seolink, :string
    add_column :artists, :seolink, :string
    add_column :tracks, :seolink, :string
  end

  def self.down
    remove_column :authors, :seolink, :string
    remove_column :stories, :seolink, :string
    remove_column :artists, :seolink, :string
    remove_column :tracks, :seolink, :string
  end
end
