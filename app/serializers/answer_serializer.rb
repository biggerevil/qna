# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :author_id, :created_at, :updated_at, :files
  has_many :links
  has_many :comments
  belongs_to :author

  def files
    object.files.map { |file| { url: rails_blob_path(file, only_path: true) } }
  end
end
