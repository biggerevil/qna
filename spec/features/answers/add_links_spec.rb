# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:gist_url) { 'https://gist.github.com/biggerevil/dd356cdb2c99455b4646f4a3a6c2cad7' }

  it 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
