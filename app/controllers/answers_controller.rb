# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    current_user.answers.push(answer)
    answer.question = question

    puts "question.answer before save = #{question.answers.inspect}"
    if answer.save
      puts "question.answer after save = #{question.answers.inspect}"
      redirect_to question, notice: 'Your answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    unless current_user.author_of?(answer)
      redirect_to question_path(answer.question), notice: 'You are not author of this answer!'
      return
    end
    answer.delete

    question = answer.question
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
