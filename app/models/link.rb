# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
