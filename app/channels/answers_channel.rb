# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}/answers"
  end

  def unsubscribed; end
end
