# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_commentable
  before_action :set_gon
  after_action :publish_comment, only: [:create]

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_gon
    gon.question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
  end

  def set_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast "question_#{question_id}/comments", comment: @comment
  end
end
