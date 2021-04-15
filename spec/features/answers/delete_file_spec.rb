# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete files from its answer', "
  In order to delete redundant or wrong file
  As an author of answer
  I'd like to be able to delete files from my answer
", js: true do
  describe 'Authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    let(:second_user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"

        click_on 'Save'
      end
    end

    it 'Author' do
      visit question_path(question)

      click_on 'Delete file'

      expect(page).not_to have_link('rails_helper.rb')
    end

    it 'Not author' do
      click_on 'Log out'
      sign_in(second_user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete file'
    end
  end
end
