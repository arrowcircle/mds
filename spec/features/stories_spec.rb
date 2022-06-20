# frozen_string_literal: true

require 'rails_helper'

feature 'Stories' do
  let(:story) { create(:story) }

  scenario 'Visits story page' do
    visit author_story_path(story.author, story)
    expect(page).to have_content story.name
  end
end
