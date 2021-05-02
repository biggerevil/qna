# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  include Voted

  expose :answer, scope: -> { Answer.with_attached_files }
  expose :question, -> { Question.find(params[:question_id]) }

  after_action :publish_answer, only: [:create]

  def create
    @answer = question.answers.new(answer_params.merge({ author: current_user }))

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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
    @question = answer.question
    return head 403 unless current_user.author_of?(@question)

    answer.make_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy id])
  end

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast "question_#{@answer.question.id}/answers", answer: @answer
  end
end
