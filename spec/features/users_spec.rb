require 'rails_helper'

feature 'Sign in' do
  scenario 'Access login page from main page' do
    visit root_url
    click_link 'Вход'
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

  scenario 'Shows error with wrong password' do
    visit new_user_session_url
    fill_in :user_email, with: 'abc@def.com'
    fill_in :user_password, with: '123123aA'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

  feature 'Sign up' do
    scenario 'Access registration page from main page' do
      visit root_url
      click_link 'Регистрация'
      expect(page).to have_content 'Email'
    end
  
    scenario 'Shows ok result for sign up' do
      u = create(:user)
      visit new_user_registration_url
      fill_in :user_email, with: 'test@mds.redde.ru'
      fill_in :user_password, with: '123123aA'
      fill_in :user_password_confirmation, with: '123123aA'
      click_button 'Sign up'
      expect(page).to have_content 'You have signed up successfully'
    end
  
    scenario 'Shows error with wrong password' do
      visit new_user_registration_url
      fill_in :user_email, with: 'abc@def.com'
      click_button 'Sign up'
      expect(page).to have_content 'Password can\'t be blank'
    end
  end
end