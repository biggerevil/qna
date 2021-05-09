# frozen_string_literal: true

module SubscriptionsHelper
  def show_subscription_links(subscribable)
    current_user_subscription = subscribable.subscriptions.where(user_id: current_user)

    if current_user_subscription.exists?
      content_tag(:b, 'You are already subscribed to the answers of this question!',
                  class: :already_subscribed) +
        tag(:br) +
        show_unsubscribe_link
    else
      show_subscribe_link
    end
  end

  private

  def show_subscribe_link
    link_to 'Subscribe to answers of this question', question_subscriptions_path(question),
            method: :post,
            remote: true,
            class: 'subscribe_to_question_link'
  end

  def show_unsubscribe_link
    link_to 'Unsubscribe', question_subscription_path(question),
            method: :delete,
            remote: true,
            class: 'unsubscribe_from_question_link'
  end
end
