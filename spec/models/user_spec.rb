# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:destroy) }

  describe 'Testing author_of? method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }

    context 'author is current user' do
      it 'returns true for question' do
        user.author_of?(question)
      end

      it 'returns true for answer' do
        user.author_of?(answer)
      end
    end

    context 'author is not current user' do
      let(:second_user) { create(:user) }

      it 'returns false for question' do
        second_user.author_of?(question)
      end

      it 'returns false for answer' do
        second_user.author_of?(answer)
      end
    end
  end
end
