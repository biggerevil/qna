# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :answer

  def create
    question = Question.find(params[:question_id])
    question.answers.push(answer)

    if answer.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
