# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote cancel_vote]
  end

  def upvote
    vote = @votable.votes.new(user_id: current_user.id, value: 1)

    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                         rating: @votable.rating, has_vote: true }
        end
      else
        format.json do
          render json: { id: @votable.id, model_name: @votable.class.to_s.downcase, errors: vote.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def downvote
    vote = @votable.votes.new(user: current_user, value: -1)

    respond_to do |format|
      if vote.save
        format.json do
          render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                         rating: @votable.rating, has_vote: true }
        end
      else
        format.json do
          render json: { id: @votable.id, model_name: @votable.class.to_s.downcase, errors: vote.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def cancel_vote
    vote = @votable.votes.find_by(user: current_user)
    vote&.destroy

    respond_to do |format|
      format.json do
        render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                       rating: @votable.rating, has_vote: false }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
