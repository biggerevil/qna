# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @answer = question.answers.create(answer_params.merge({ author: current_user }))
  end

  def update
    @answer = Answer.find(params[:id])
    return unless current_user.author_of?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return unless current_user.author_of?(answer)

    @answer = Answer.find(params[:id])
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
