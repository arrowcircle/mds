# frozen_string_literal: true

require 'rails_helper'

feature 'Sign in' do
  scenario 'Access login page from main page' do
    visit root_url
    first(:link, "Войти").click
    expect(page).to have_content 'Email'
  end

  scenario 'Shows ok result for sign in' do
    u = create(:user)
    visit users.sign_in_path
    fill_in :passwordless_email, with: u.email
    first(:button, "Получить ссылку").click
    session = Passwordless::Session.first
    skip "В транзакции не работает"
    link = send(Passwordless.mounted_as).token_sign_in_url(session.token)
    visit link
    expect(page).to have_content 'Вход в систему выполнен'
  end

  feature 'Sign up' do
    scenario 'Access registration page from main page' do
      visit root_url
      first(:link, 'Регистрация').click
      expect(page).to have_content 'Email'
    end
  end

  feature 'Index' do
    it 'Accesses users from main page' do
      visit root_url
      first(:link, 'Участники').click
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
      visit users_path(q: u1.username)
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
