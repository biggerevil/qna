# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit its question', "
  In order to correct or improve question
  As an author of question
  I'd like to edit my question
" do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  context 'Author', js: true do
    before do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit question'
    end

    it 'edits its answer' do
      within '.question' do
        fill_in 'Question title', with: 'Edited title'
        fill_in 'Question body', with: 'Edited body'

        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'edits its answer with errors' do
      within '.question' do
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''

        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
    end
  end

  context 'Not author', js: true do
    let(:second_user) { create(:user) }

    it "can't edit question" do
      sign_in(second_user)
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Edit question'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end
end
