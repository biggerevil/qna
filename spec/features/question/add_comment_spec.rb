# frozen_string_literal: true

require 'rails_helper'

describe 'User can comment questions', "
  In order to note something
  As an authenticated user
  I'd like to be able to comment questions
", js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'creates comment' do
      within '.new-question-comment' do
        fill_in 'Your comment', with: 'New comment'
        click_on 'Create Comment'
      end

      expect(page).to have_content 'New comment'
    end

    it "can't create empty comment" do
      within '.new-question-comment' do
        fill_in 'Your comment', with: ''
        click_on 'Create Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Multiply sessions' do
    it "comment appears on another user's page" do
      Capybara.using_session('another_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.new-question-comment' do
          fill_in 'Your comment', with: 'New comment'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'New comment'
      end
    end
  end

  it "Unauthenticated user can't comment" do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_button 'Create Comment'
    end
  end
end
