# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_question, only: %i[create destroy]

  def create
    authorize! :create, Subscription
    @subscription = @question.subscriptions.new(user: current_user)

    @subscription.save
  end

  def destroy
    @subscription = @question.subscriptions.where(user_id: current_user).first
    authorize! :destroy, @subscription

    @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
