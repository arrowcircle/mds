# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    username { FFaker::Internet.user_name }
    password { '123123aA' }
    confirmed_at { 1.day.ago }
  end
end
