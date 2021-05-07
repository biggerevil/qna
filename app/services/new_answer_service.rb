# frozen_string_literal: true

class NewAnswerService
  def notify(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.new_answer(answer, subscription.user).deliver_later
    end
  end
end
