# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    author
    name { FFaker::Book.title }
  end
end
