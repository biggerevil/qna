# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete links from answer', "
  In order to correct my answer
  As an answer's author
  I'd like to be able to delete links
", js: true do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author) }
  let!(:link) { create(:link, linkable: answer) }

  let(:second_user) { create(:user) }

  it 'Author deletes link' do
    sign_in(author)
    visit question_path(question)

    within "#links_for_answer_#{answer.id}" do
      click_on 'Delete link'
      expect(page).not_to have_link link.name
    end
  end

  it "Not author doesn't see Delete link" do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end
