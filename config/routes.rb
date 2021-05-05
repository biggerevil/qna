# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :cancel_vote
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
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
