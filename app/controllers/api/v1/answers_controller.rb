# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :find_answer, only: %i[show update destroy]

      authorize_resource

      def index
        @answers = Question.find(params[:question_id]).answers
        render json: @answers, each_serializer: AnswerSerializer
      end

      def show
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        @answer = Question.find(params[:question_id]).answers.create(answer_params)
        @answer.author = current_resource_owner

        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: @answer.errors.messages.to_json, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer, serializer: AnswerSerializer
        else
          render json: @answer.errors.messages.to_json, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy
      end

      private

      def find_answer
        @answer = Answer.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:title, :body, files: [],
                                                      links_attributes: %i[name url id _destroy])
      end
    end
  end
end
