# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:gist_url) { 'https://gist.github.com/biggerevil/dd356cdb2c99455b4646f4a3a6c2cad7' }

  it 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
