# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files
  has_many :answers
  has_many :links
  has_many :comments
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| { url: rails_blob_path(file, only_path: true) } }
    # Rails.application.routes.url_helpers.rails_representation_url(picture_of_car.variant(resize: "300x300").processed, only_path: true)
  end
end
