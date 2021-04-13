# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }

  describe '#make_best' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:first_answer) { create(:answer, author: author, question: question) }
    let(:second_answer) { create(:answer, author: author, question: question) }

    it 'makes answer best' do
      first_answer.make_best

      expect(first_answer.is_best).to be_truthy
    end

    it 'makes another answer best' do
      first_answer.update!(is_best: true)

      second_answer.make_best
      first_answer.reload

      expect(second_answer.is_best).to be_truthy
      expect(first_answer.is_best).to be_falsey
    end
  end
end
