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

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], except: %i[index show], shallow: true do
      patch :make_best, on: :member
    end

    resources :votes, only: %i[create destroy], shallow: true
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
end
