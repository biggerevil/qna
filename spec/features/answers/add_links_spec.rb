# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
", js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:google_url) { 'https://google.com' }
  let(:yandex_url) { 'https://yandex.com' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  it 'User adds link when give an answer', js: true do
    fill_in 'Body', with: 'My answer'

    fill_in 'Name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
    end
  end

  it 'User adds several links when gives an answer' do
    fill_in 'Body', with: 'My answer'

    fill_in 'Name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end
  end
end
