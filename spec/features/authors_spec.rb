# frozen_string_literal: true

require "rails_helper"

feature "Authors" do
  let(:author) { create(:author) }

  scenario "Visits authors page" do
    author
    visit authors_url
    expect(page).to have_content author.name
    click_link author.name
    expect(page).to have_content author.name
  end

  scenario "Visits author page" do
    visit author_url(author)
    expect(page).to have_content author.name
  end
end
