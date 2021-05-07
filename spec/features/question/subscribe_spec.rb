# frozen_string_literal: true

require 'rails_helper'

describe 'User can subscribe to new answers of question', "
  In order to know about new answers of the question
  As a user
  I'd like to be able to subscribe to answer
  ", js: true do
  let!(:question) { create(:question) }

  context 'Authenticated' do
    let(:user) { create(:user) }
    let(:question_with_author) { create(:question, author: author) }
    let(:author) { create(:user) }
    let(:author) { create(:user) }
    let(:question_with_author) { create(:question, author: author) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'Can subscribe and unsubscribe' do
      click_on 'Subscribe to answers of this question'
      expect(page).to have_content 'You are subscribed!'

      visit question_path(question)

      click_on 'Unsubscribe'
      expect(page).to have_content 'You are now unsubscribed!'

      visit question_path(question)

      expect(page).to have_content 'Subscribe to answers of this question'
    end

    context 'author of question' do
      before do
        click_on 'Log out'
        sign_in(author)
      end

      it 'author is subscribed by default' do
        visit question_path(question_with_author)

        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  context 'Unauthenticated' do
    before { visit question_path(question) }

    it "Can't subscribe or unsubscribe" do
      expect(page).not_to have_link 'Subscribe to answers of this question'
      expect(page).not_to have_link 'Unsubscribe'
    end
  end
end
