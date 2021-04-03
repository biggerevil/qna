# frozen_string_literal: true

FactoryBot.define do
  sequence :answer_body do |n|
    "Answer ##{n}"
  end

  factory :answer do
    body { generate(:answer_body) }
    question { nil }
    author { association :user }

    trait :invalid do
      body { nil }
    end
  end
end
