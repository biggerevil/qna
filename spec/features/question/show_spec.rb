# frozen_string_literal: true

require 'rails_helper'

describe 'User can see question and answers of it', "
  In order to find solution to my problem
  As a user
  I'd like to be able to see question and its answers
  " do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  it 'User can see question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
