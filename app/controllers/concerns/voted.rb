# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote cancel_vote]
  end

  def upvote
    authorize! :upvote, @votable

    vote = @votable.votes.new(user_id: current_user.id, value: 1)

    if vote.save
      render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                     rating: @votable.rating, has_vote: true }
    else
      render json: { id: @votable.id, model_name: @votable.class.to_s.downcase, errors: vote.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def downvote
    authorize! :downvote, @votable

    vote = @votable.votes.new(user: current_user, value: -1)

    if vote.save
      render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                     rating: @votable.rating, has_vote: true }
    else
      render json: { id: @votable.id, model_name: @votable.class.to_s.downcase, errors: vote.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def cancel_vote
    authorize! :cancel_vote, @votable

    vote = @votable.votes.find_by(user: current_user)
    vote&.destroy

    render json: { id: @votable.id, model_name: @votable.class.to_s.downcase,
                   rating: @votable.rating, has_vote: false }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
