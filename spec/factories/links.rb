# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://google.com' }
  end
end
