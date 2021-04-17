# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope -> { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def make_best
    previous_best = question.best_answer

    Answer.transaction do
      previous_best&.update!(best: false)
      update!(best: true)
    end
  end
end
