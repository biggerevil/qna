# frozen_string_literal: true

FactoryBot.define do
  factory :badge do
    question
    title { 'Badge Title!' }
    after(:build) do |badge|
      badge.image.attach(io: File.open("#{Rails.root}/spec/support/image.jpg"),
                         filename: 'image.jpg')
    end
  end
end
