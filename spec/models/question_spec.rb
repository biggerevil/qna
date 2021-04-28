# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable_spec.rb')

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to have_one(:badge).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :badge }

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:first_answer) { create(:answer, author: author, question: question) }
    let(:second_answer) { create(:answer, author: author, question: question) }

    it 'returns best answer if there is one' do
      first_answer.update!(best: true)

      expect(question.best_answer).to eq first_answer
    end

    it 'returns nil if there is no best answer' do
      expect(question.best_answer).to be_nil
    end
  end
end
