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
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    unless current_user.author_of?(answer)
      redirect_to question_path(answer.question), notice: 'You are not author of this answer!'
      return
    end
    answer.destroy

    question = answer.question
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
