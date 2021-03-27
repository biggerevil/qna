# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyString' }
    question { nil }
  end
end
