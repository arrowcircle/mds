class ChangeOldData < ActiveRecord::Migration
  def up
    remove_column :authors, :seolink
    remove_column :stories, :seolink
    remove_column :artists, :seolink
    remove_column :tracks, :seolink
    remove_column :playlists, :requested
    remove_column :stories, :full
  end

  def down
  end
end
