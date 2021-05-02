# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['question_id']}/comments"
  end

  def unsubscribed; end
end
