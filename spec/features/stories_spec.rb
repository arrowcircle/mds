# frozen_string_literal: true

require "rails_helper"

feature "Stories" do
  let(:story) { create(:story) }

  scenario "Visits story page" do
    visit author_story_path(story.author, story)
    expect(page).to have_content story.name
  end

  scenario "Player frame is ready to host a full-width player" do
    visit author_story_path(story.author, story)

    expect(page).to have_css("turbo-frame#player.w-full")
    expect(page).to have_no_css("turbo-frame#player.w-max")
  end
end
