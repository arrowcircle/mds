require 'rails_helper'

feature 'Main page' do
  scenario 'Visits main page' do
    visit root_url
    expect(page).to have_content 'Welcome'
  end
end
