# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete its answer', "
  In order to remove my answer
  As a user
  I'd like to delete my answer
" do
  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user', js: true do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'Tries to delete its answer' do
      answers.second.update!(author: user)

      visit question_path(question)

      expect(page).to have_content(answers.second.body)
      click_on 'Delete answer'
      expect(page).not_to have_content(answers.second.body)
    end

    it 'Tries to delete not its answer' do
      visit question_path(question)

      expect(page).not_to have_link('Delete answer')
    end
  end

  it 'Unauthenticated user tries to delete answer', js: true do
    visit question_path(question)

    expect(page).not_to have_link('Delete answer')
  end
end
