# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  let(:votable_name) { described_class.controller_name.singularize.to_sym }
  let(:votable) { create(votable_name) }
  let(:user) { create(:user) }

  describe 'POST #upvote' do
    describe 'Authenticated user' do
      before { sign_in(user) }

      context 'User is not votable author' do
        it 'assigns votable' do
          post :upvote, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'user has a new vote' do
          old_user_votes_count = user.votes.count
          post :upvote, params: { id: votable }, format: :json

          expect(user.votes.count).to eq old_user_votes_count + 1
          expect(votable.rating).to eq 1
        end

        it 'responds with json' do
          post :upvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'User is author of votable' do
        before { sign_in(votable.author) }

        it 'assigns votable' do
          post :upvote, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it "doesn't create new vote" do
          expect do
            post :upvote, params: { id: votable }, format: :json
          end.not_to change(votable.author.votes, :count)
        end

        it 'responds with json' do
          post :upvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end

    describe 'Unauthenticated user' do
      before { sign_out(user) }

      it 'returns unauthorized' do
        post :upvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #downvote' do
    describe 'Authenticated user' do
      before { sign_in(user) }

      context 'User is not votable author' do
        it 'assigns votable' do
          post :downvote, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'creates new downvote' do
          old_user_votes_count = user.votes.count
          post :downvote, params: { id: votable }, format: :json

          expect(user.votes.count).to eq old_user_votes_count + 1
          expect(votable.rating).to eq(-1)
        end

        it 'responds with json' do
          post :downvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'User is author of votable' do
        before { sign_in(votable.author) }

        it 'assigns votable' do
          post :downvote, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it "doesn't create new vote" do
          expect do
            post :downvote, params: { id: votable },
                            format: :json
          end.not_to change(votable.author.votes, :count)
        end

        it 'responds with json' do
          post :downvote, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end

    describe 'Unauthenticated user' do
      before { sign_out(user) }

      it 'responses with unauthorized status' do
        post :downvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    let!(:vote) { create(:vote, votable: votable) }
    let(:another_user) { create(:user) }

    context 'Authenticated user' do
      context 'Author of vote' do
        before { sign_in(vote.user) }

        it 'deletes vote' do
          expect do
            delete :cancel_vote, params: { id: vote.votable },
                                 format: :json
          end.to change(vote.votable.votes, :count).by(-1)
        end

        it 'responds with json' do
          delete :cancel_vote, params: { id: vote.votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'Not vote author' do
        before { sign_in(another_user) }

        it "doesn't delete vote" do
          expect do
            delete :cancel_vote, params: { id: votable },
                                 format: :json
          end.not_to change(vote.user.votes, :count)
        end

        it 'responds with json' do
          delete :cancel_vote, params: { id: vote.votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end

    context 'Unauthenticated user' do
      before { sign_out(user) }

      it 'does not deletes vote' do
        expect do
          delete :cancel_vote, params: { id: votable }, format: :json
        end.not_to change(votable.votes, :count)
      end

      it 'responses with unauthorized status' do
        delete :cancel_vote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
