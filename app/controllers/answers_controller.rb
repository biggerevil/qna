# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose :answer, scope: -> { Answer.with_attached_files }
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @answer = question.answers.create(answer_params.merge({ author: current_user }))
  end

  def update
    @answer = Answer.find(params[:id])
    return head 403 unless current_user.author_of?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return head 403 unless current_user.author_of?(answer)

    @answer = Answer.find(params[:id])
    @answer.destroy
  end

  def make_best
    return head 403 unless current_user.author_of?(answer)

    @question = answer.question
    answer.make_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy id])
  end
end
