# frozen_string_literal: true

class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerService.new.notify(answer)
  end
end
