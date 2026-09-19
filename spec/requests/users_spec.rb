# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  it "registers a user" do
    expect {
      post users_path, params: {user: {email: "new@example.com", username: "newbie"}}
    }.to change(User, :count).by(1)

    expect(response).to redirect_to(root_path)
    expect(User.last).to have_attributes(email: "new@example.com", username: "newbie")
  end
end
