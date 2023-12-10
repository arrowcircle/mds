class AddAudioDataToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :audio_data, :jsonb
  end
end
