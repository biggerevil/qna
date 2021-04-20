# frozen_string_literal: true

class Badge < ApplicationRecord
  belongs_to :question

  has_one_attached :image

  validates :title, :image, presence: true
end
