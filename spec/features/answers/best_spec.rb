# frozen_string_literal: true

require 'rails_helper'

describe 'User can choose answer as best', "
  In order to show that answer helped with my question
  As an author of question
  I'd like to be able to mark answer as best
", js: true do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let!(:first_answer) { create(:answer, question: question, author: author) }
  let!(:second_answer) { create(:answer, question: question, author: author) }

  context 'Author of question' do
    before { sign_in(author) }

    it 'can mark answer as best' do
      visit question_path(question)
      within "#answer-#{first_answer.id}" do
        click_on 'Make best'

        expect(page).to have_content 'Best'
        expect(page).not_to have_link 'Make best'
      end
    end

    it 'can choose another answer as best' do
      first_answer.update!(best: true)

      visit question_path(question)

      within "#answer-#{second_answer.id}" do
        click_on 'Make best'

        expect(page).to have_content 'Best'
        expect(page).not_to have_link 'Make best'
      end

      within "#answer-#{first_answer.id}" do
        expect(page).to have_link 'Make best'
        expect(page).not_to have_content 'Best'
      end
    end

    it 'best answer above others' do
      first_answer.update!(best: true)

      visit question_path(question)

      first_element = find('.answers').first('p')
      expect(first_element[:id]).to eq "answer-#{first_answer.id}"
    end
  end

  context 'Not author' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it "can't mark answer as best" do
      visit question_path(question)

      expect(page).not_to have_link 'Make best'
    end
  end

  context 'Not authenticated user' do
    it "can't mark answer as best" do
      visit question_path(question)

      expect(page).not_to have_link 'Make best'
    end
  end
end
