# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  scope :all_for_day_before, -> { where('created_at > ?', 1.day.ago) }

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :badge, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.where(best: true).first
  end

  after_create :calculate_reputation
  after_create :subscribe_author

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    self.subscriptions.create(user: author)
  end
end
