# frozen_string_literal: true

require "rails_helper"
require "passwordless/test_helpers"

RSpec.describe "Artists", type: :request do
  include Passwordless::TestHelpers::RequestTestCase

  it "redirects to the artists list after destroy" do
    passwordless_sign_in(create(:user, email: User::ADMINS.first))
    artist = Artist.create!(name: "To Delete")

    delete artist_path(artist)

    expect(response).to redirect_to(artists_path)
    expect(Artist.find_by(id: artist.id)).to be_nil
  end
end
