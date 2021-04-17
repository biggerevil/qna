# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :links }

  it { is_expected.to validate_presence_of :body }

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#make_best' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:first_answer) { create(:answer, author: author, question: question) }
    let(:second_answer) { create(:answer, author: author, question: question) }

    it 'makes answer best' do
      first_answer.make_best

      expect(first_answer).to be_best
    end

    it 'makes another answer best' do
      first_answer.update!(best: true)

      second_answer.make_best
      first_answer.reload

      expect(second_answer).to be_best
      expect(first_answer).not_to be_best
    end
  end
end
