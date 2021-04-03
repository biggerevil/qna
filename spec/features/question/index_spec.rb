# frozen_string_literal: true

require 'rails_helper'

describe 'User can see all questions', "
  In order to find question I need
  As a user
  I'd like to be able to see all questions
  " do
  let!(:questions) { create_list(:question, 3) }

  it 'User can see titles of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
