# frozen_string_literal: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  let(:user) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    it 'asks a question' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    it 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  it 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
