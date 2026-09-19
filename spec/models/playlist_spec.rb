# frozen_string_literal: true

require "rails_helper"

RSpec.describe Playlist do
  def identify!(artist_name:, track_name:, artist_id: nil)
    create(:story).playlists.create!(
      artist_name:,
      track_name:,
      artist_id:,
      start_min: 1,
      end_min: 2
    )
  end

  it "does not attach a typed artist name to a longer name that contains it" do
    Artist.create!(name: "Klartraum, Nadja Lind, Helmut Ebritsch")

    playlist = identify!(artist_name: "Helmut Ebritsch", track_name: "What I Am")

    expect(playlist.track.artist.name).to eq("Helmut Ebritsch")
    expect(Artist.where("name ILIKE ?", "%Helmut Ebritsch%").pluck(:name)).to contain_exactly(
      "Klartraum, Nadja Lind, Helmut Ebritsch",
      "Helmut Ebritsch"
    )
  end

  it "reuses an existing artist with the same name" do
    artist = Artist.create!(name: "Helmut Ebritsch")

    playlist = identify!(artist_name: "helmut ebritsch", track_name: "What I Am")

    expect(playlist.track.artist).to eq(artist)
  end

  it "does not attach a typed track name to a longer name that contains it" do
    artist = Artist.create!(name: "Klartraum")
    artist.tracks.create!(name: "Super Moon")

    playlist = identify!(artist_name: "Klartraum", track_name: "Moon")

    expect(playlist.track.name).to eq("Moon")
    expect(artist.tracks.order(:name).pluck(:name)).to eq(["Moon", "Super Moon"])
  end
end
