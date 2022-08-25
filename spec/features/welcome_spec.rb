# frozen_string_literal: true

require "rails_helper"

feature "Main page" do
  scenario "Visits main page" do
    visit root_url
    expect(page).to have_content "МДС Музыка"
  end
end
