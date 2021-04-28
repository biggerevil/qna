# frozen_string_literal: true

require 'rails_helper'

describe 'User can vote for answer and see rating of it', "
  In order to show and see how useful answer was
  As a user
  I'd like to be able to vote for answer and see its rating
  ", js: true do
  let(:user) { create(:user) }
  let(:author_of_answer) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: author_of_answer) }

  describe 'Authenticated user' do
    describe 'Not author of answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      it 'Upvotes for answer' do
        within "#answer-#{answer.id}" do
          click_on 'Upvote'
          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      it 'Downvotes for answer' do
        within "#answer-#{answer.id}" do
          click_on 'Upvote'
          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      it 'Cancels votes' do
        within "#answer-#{answer.id}" do
          click_on 'Upvote'
          click_on 'Cancel vote'
          within '.rating' do
            expect(page).to have_content 0
          end
        end
      end
    end

    describe 'Author of answer' do
      before do
        sign_in(author_of_answer)
        visit question_path(question)
      end

      it "Can't upvote, downvote or cancel" do
        within "#answer-#{answer.id}" do
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
      within "#answer-#{answer.id}" do
        expect(page).not_to have_link 'Upvote'
        expect(page).not_to have_link 'Downvote'
        expect(page).not_to have_link 'Cancel vote'
      end
    end
  end
end
