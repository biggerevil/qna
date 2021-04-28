# frozen_string_literal: true

module VotesHelper
  def show_rating_of(votable)
    content_tag(:b, votable.rating, class: :rating)
  end

  def add_vote_links_to(votable)
    vote = votable.votes.first
    if !vote.nil?
      cancel_vote_link(votable) +
        upvote_link(votable, 'hidden') + ' ' + downvote_link(votable, 'hidden')
    else
      upvote_link(votable) + ' ' + downvote_link(votable) +
        cancel_vote_link(votable, 'hidden')
    end
  end

  private

  def upvote_link(votable, additional_class = '')
    link_to 'Upvote', polymorphic_path(votable, action: :upvote),
            method: :post,
            remote: true,
            data: { type: 'json' },
            class: "upvote_link vote_link #{additional_class}"
  end

  def downvote_link(votable, additional_class = '')
    link_to 'Downvote', polymorphic_path(votable, action: :downvote),
            method: :post,
            remote: true,
            data: { type: 'json' },
            class: "downvote_link vote_link #{additional_class}"
  end

  def cancel_vote_link(votable, additional_class = '')
    link_to 'Cancel vote', polymorphic_path(votable, action: :cancel_vote),
            method: :delete,
            remote: true,
            data: { type: 'json' },
            class: "cancel_vote_link vote_link #{additional_class}"
  end
end
