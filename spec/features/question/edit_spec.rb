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

    it 'edits its question' do
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'

        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'edits its question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''

        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
    end

    it 'edits its question and adds files' do
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        attach_file 'Files',
                    ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_content 'Edited title'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    it 'edits its question and adds links' do
      within '.question' do
        fill_in 'Title', with: 'Question with link'

        click_on 'Add link'

        fill_in 'Name', with: 'Bing'
        fill_in 'Url', with: 'https://bing.com'

        click_on 'Save'

        expect(page).to have_content 'Question with link'
        expect(page).to have_link 'Bing', href: 'https://bing.com'
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
