# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Question ##{n}"
  end

  sequence :body do |n|
    "Text of question ##{n}"
  end

  factory :question do
    title
    body
    author { association :user }

    trait :invalid do
      title { nil }
    end
  end
end
