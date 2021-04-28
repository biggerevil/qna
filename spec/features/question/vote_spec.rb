# frozen_string_literal: true

require 'rails_helper'

describe 'User can vote for question and see rating of it', "
  In order to show and see how useful question was
  As a user
  I'd like to be able to vote for question and see its rating
  ", js: true do
  let(:user) { create(:user) }
  let(:author_of_question) { create(:user) }
  let!(:question) { create(:question, author: author_of_question) }

  describe 'Authenticated user' do
    describe 'Not author of question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      it 'Upvotes for question' do
        within "#question-#{question.id}" do
          click_on 'Upvote'
          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      it 'Downvotes for question' do
        within "#question-#{question.id}" do
          click_on 'Upvote'
          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      it 'Cancels votes' do
        within "#question-#{question.id}" do
          click_on 'Upvote'
          click_on 'Cancel vote'
          within '.rating' do
            expect(page).to have_content 0
          end
        end
      end
    end

    describe 'Author of question' do
      before do
        sign_in(author_of_question)
        visit question_path(question)
      end

      it "Can't upvote, downvote or cancel" do
        within "#question-#{question.id}" do
          expect(page).not_to have_link 'Upvote'
          expect(page).not_to have_link 'Downvote'
          expect(page).not_to have_link 'Cancel vote'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    before do
      visit question_path(question)
    end

    it "Can't upvote, downvote or cancel" do
      within "#question-#{question.id}" do
        expect(page).not_to have_link 'Upvote'
        expect(page).not_to have_link 'Downvote'
        expect(page).not_to have_link 'Cancel vote'
      end
    end
  end
end
