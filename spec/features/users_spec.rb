require 'rails_helper'

feature 'Sign in' do
  scenario 'Access login page from main page' do
    visit root_url
    click_link 'Войти'
    expect(page).to have_content 'Email'
  end

  scenario 'Shows ok result for sign in' do
    u = create(:user)
    visit new_user_session_url
    fill_in :user_email, with: u.email
    fill_in :user_password, with: '123123aA'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Shows error' do
    visit new_user_session_url
    expect(page).to have_content 'Welcome'
  end
end
