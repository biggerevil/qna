# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], except: %i[index show], shallow: true do
      patch :make_best, on: :member
    end

    resources :votes, only: %i[create destroy], shallow: true
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => '/cable'
end
