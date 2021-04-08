# frozen_string_literal: true

require 'rails_helper'

describe 'User can create answer', "
  In order to help with question to other people
  As a user
  I'd like to be able to answer question
" do
  let(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    before { visit question_path(question) }

    it 'can answer question', js: true do
      fill_in 'answer_body', with: 'New answer'
      click_on 'Create Answer'

      expect(page).to have_content 'New answer'
    end

    it "can't create empty answer", js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'Not authenticated user' do
    before { visit question_path(question) }

    it 'User tries to answer question' do
      fill_in 'answer_body', with: 'New answer'
      click_on 'Create Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
