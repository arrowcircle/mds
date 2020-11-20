# frozen_string_literal: true

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
    click_button 'Войти'
    expect(page).to have_content 'Вход в систему выполнен'
  end

  scenario 'Shows error with wrong password' do
    visit new_user_session_url
    fill_in :user_email, with: 'abc@def.com'
    fill_in :user_password, with: '123123aA'
    click_button 'Войти'
    expect(page).to have_content 'Неправильный Email или пароль'
  end

  feature 'Sign up' do
    scenario 'Access registration page from main page' do
      visit root_url
      click_link 'Регистрация'
      expect(page).to have_content 'Email'
    end

    scenario 'Shows confirmation requirement after sign up' do
      create(:user)
      visit new_user_registration_url
      fill_in :user_email, with: FFaker::Internet.email
      fill_in :user_username, with: FFaker::Internet.user_name
      fill_in :user_password, with: '123123aA'
      fill_in :user_password_confirmation, with: '123123aA'
      click_button 'Регистрация'
      expect(page).to have_content 'подтвердить учетную запись'
    end

    scenario 'Shows error with wrong password' do
      visit new_user_registration_url
      fill_in :user_email, with: 'abc@def.com'
      click_button 'Регистрация'
      expect(page).to have_content 'Пароль не может быть пустым'
    end
  end

  feature 'Index' do
    it 'Accesses users from main page' do
      visit root_url
      click_link 'Участники'
      expect(page).to have_content 'Участники проекта'
    end

    it 'Shows users page' do
      u1 = create(:user)
      u2 = create(:user)
      visit users_path
      expect(page).to have_content u1.username
      expect(page).to have_content u2.username
    end

    it 'Searches user' do
      u1 = create(:user)
      u2 = create(:user)
      visit users_path(search: u1.username)
      expect(page).to have_content u1.username
      expect(page).not_to have_content u2.username
    end

    it 'Shows user profile' do
      u = create(:user)
      visit users_path
      click_link u.username
      expect(page).to have_content u.username
    end
  end
end
