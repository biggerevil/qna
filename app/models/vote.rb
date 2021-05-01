# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, :votable, presence: true
  validates :value, inclusion: { in: [-1, 1] }, presence: true
  validate :author_cannot_vote

  private

  def author_cannot_vote
    errors.add(:user, 'Author cannot vote for its resources') if user&.author_of?(votable)
  end
end
