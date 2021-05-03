# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  include Voted

  expose :question, -> { Question.find(params[:question_id]) }

  before_action :set_answer, except: :create

  authorize_resource

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
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def make_best
    @question = @answer.question

    @answer.make_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_#{@answer.question.id}/answers", answer: @answer
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = answer.question
  end
end
