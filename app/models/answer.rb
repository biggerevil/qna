# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope -> { order(best: :desc, created_at: :asc) }

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :notify_subscribed

  def make_best
    previous_best = question.best_answer

    Answer.transaction do
      if previous_best&.persisted?
        previous_best.update!(best: false)
        previous_best.author.badges.delete(question.badge) unless question.badge.nil?
      end

      update!(best: true)
      question.badge&.update!(user: author)
    end
  end

  private

  def notify_subscribed
    NewAnswerJob.perform_later(self)
  end
end
