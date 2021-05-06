# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :find_question, only: %i[show update destroy]

      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question
      end

      def create
        @question = Question.new(question_params)
        @question.author = current_resource_owner

        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          render json: @question.errors.messages.to_json, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          render json: @question.errors.messages.to_json, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
      end

      private

      def find_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body, files: [],
                                                        links_attributes: %i[name url id _destroy],
                                                        reward_attributes: %i[name image])
      end
    end
  end
end
