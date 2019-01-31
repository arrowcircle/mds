FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { '123123aA' }
  end
end