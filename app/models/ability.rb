# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Subscription]

    can %i[update destroy], [Question, Answer], author_id: user.id
    can :destroy, Subscription, user_id: user.id

    can :make_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can [:upvote, :downvote, :cancel_vote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :me, User do |profile|
      profile.id == user.id
    end
  end
end
