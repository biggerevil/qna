# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
", js: true do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'Author' do
      before do
        sign_in user
        visit question_path(question)

        click_on 'Edit'
      end

      it 'edits his answer' do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).not_to have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).not_to have_selector 'textarea'
        end
      end

      it 'edits his answer with errors' do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_selector 'textarea'
        end

        expect(page).to have_content "Body can't be blank"
      end

      it 'edits his answer and adds files' do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'

          attach_file 'Files',
                      ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_content 'edited answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      it "tries to edit other user's answer" do
        sign_in(second_user)
        visit question_path(question)

        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
