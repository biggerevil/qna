# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
", js: true do
  let(:user) { create(:user) }
  let(:google_url) { 'https://google.com' }
  let(:yandex_url) { 'https://yandex.com' }

  before do
    sign_in(user)
    visit new_question_path
  end

  it 'User adds link when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
  end

  it 'User adds several links when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.nested-fields' do
      fill_in 'Name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
    expect(page).to have_link 'Yandex', href: yandex_url
  end

  context 'User enters link with wrong format' do
    before do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Name', with: 'Wrong link'
      fill_in 'Url', with: 'url_in_wrong_format'

      click_on 'Ask'
    end

    it 'User stays on page with new question' do
      expect(page).to have_button 'Ask'
    end

    it 'Mistake about wrong format is shown' do
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
