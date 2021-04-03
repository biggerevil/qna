# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete its questions', "
  In order to delete my question
  As a user
  I'd like to be able to delete my question
" do
  describe 'Authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    let(:second_user) { create(:user) }
    let(:second_question) { create(:question, author: second_user) }

    before { sign_in(user) }

    it 'Author' do
      visit question_path(question)

      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully deleted.'
    end

    it 'Not author' do
      visit question_path(second_question)

      expect(page).not_to have_content 'Delete question'
    end
  end

  describe 'Not authenticated user tries to delete question' do
    let(:question) { create(:question) }

    it 'Unauthenticated user tries to delete question' do
      visit question_path(question)

      expect(page).not_to have_content 'Delete question'
    end
  end
end
