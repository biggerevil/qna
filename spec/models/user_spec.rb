# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:user_badges).dependent(:destroy) }
  it { is_expected.to have_many(:badges) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:second_user) { create(:user) }

    it 'Returns true for author' do
      expect(user).to be_author_of(question)
    end

    it 'Returns false for not author' do
      expect(second_user).not_to be_author_of(question)
    end
  end
end
