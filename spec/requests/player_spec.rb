# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Player", type: :request do
  describe "POST /player" do
    it "renders the bottom player without cramped legacy markup" do
      story = create(:story, external_audio_url: "https://example.com/perimetr.mp3")

      post player_path(play: story.play_item_string), headers: {"Accept" => "text/vnd.turbo-stream.html"}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('data-controller="player"')
      expect(response.body).to include("mds-player")
      expect(response.body).to include("mds-player__timeline")
      expect(response.body).to include("theme-icon")
      expect(response.body).to include("<svg")
      expect(response.body).not_to include('<img class="theme-icon')
      expect(response.body).not_to include("Meduza - Ololo")
    end

    it "renders story playlist data for the live current-track label" do
      story = create(:story, external_audio_url: "https://example.com/perimetr.mp3")
      artist = Artist.create!(name: "Groove Armada")
      track = artist.tracks.create!(name: "At The River")
      story.playlists.create!(track:, start_min: 0, end_min: 4)

      post player_path(play: story.play_item_string), headers: {"Accept" => "text/vnd.turbo-stream.html"}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('data-player-target="currentTrack"')
      expect(response.body).to include("Groove Armada - At The River")
      expect(response.body).not_to include("btn-primary btn-circle")
    end
  end
end
