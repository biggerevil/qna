# frozen_string_literal: true

class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :user_badge, dependent: :destroy, optional: true
  has_one :user, through: :user_badge

  has_one_attached :image

  validates :title, :image, presence: true
end
