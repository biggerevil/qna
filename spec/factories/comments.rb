# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Comment body' }

    trait :invalid do
      body { nil }
    end
  end
end
