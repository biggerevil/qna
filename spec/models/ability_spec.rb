# frozen_string_literal: true

require 'rails_helper'

describe Ability do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    context 'Questions' do
      it { is_expected.to be_able_to :create, Question }
      it { is_expected.to be_able_to :update, create(:question, author_id: user.id) }
      it { is_expected.not_to be_able_to :update, create(:question, author_id: other.id) }
      it { is_expected.to be_able_to :destroy, create(:question, author_id: user.id) }
      it { is_expected.not_to be_able_to :destroy, create(:question, author_id: other.id) }
    end

    context 'Answers' do
      it { is_expected.to be_able_to :create, Answer }
      it { is_expected.to be_able_to :update, create(:answer, author_id: user.id) }
      it { is_expected.not_to be_able_to :update, create(:answer, author_id: other.id) }
      it { is_expected.to be_able_to :destroy, create(:answer, author_id: user.id) }
      it { is_expected.not_to be_able_to :destroy, create(:answer, author_id: other.id) }
    end

    context 'Comments' do
      it { is_expected.to be_able_to :create, Comment }
    end

    context 'Links' do
      it {
        expect(subject).to be_able_to :destroy,
                                      create(:link, linkable: create(:question, author_id: user.id))
      }

      it {
        expect(subject).not_to be_able_to :destroy,
                                          create(:link,
                                                 linkable: create(:question, author_id: other.id))
      }
    end

    context 'Votes' do
      # Questions
      it {
        expect(subject).to be_able_to %i[upvote downvote cancel_vote],
                                      create(:question, author_id: other.id)
      }

      it {
        expect(subject).not_to be_able_to %i[upvote downvote cancel_vote],
                                          create(:question, author_id: user.id)
      }

      # Answers
      it {
        expect(subject).to be_able_to %i[upvote downvote cancel_vote],
                                      create(:answer, author_id: other.id)
      }

      it {
        expect(subject).not_to be_able_to %i[upvote downvote cancel_vote],
                                          create(:answer, author_id: user.id)
      }
    end
  end
end
