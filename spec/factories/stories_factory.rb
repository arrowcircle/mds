# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    author
    title { FFaker::Book.title }
  end
end
