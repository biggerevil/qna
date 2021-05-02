# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { sign_in(author) }

      context 'With valid attributes' do
        it 'saves new comment' do
          expect do
            post :create, params: { comment: attributes_for(:comment), question_id: question },
                          format: :js
          end.to change(question.comments, :count).by(1)
        end

        it 'assigns commentable' do
          post :create, params: { comment: attributes_for(:comment), question_id: question },
                        format: :js
          expect(assigns(:commentable)).to eq question
        end

        it 'renders create template' do
          post :create,
               params: { comment: attributes_for(:comment), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it "doesn't save comment" do
          expect do
            post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question },
                          format: :js
          end.not_to change(Comment, :count)
        end

        it 'renders create template' do
          post :create,
               params: { comment: attributes_for(:comment, :invalid), question_id: question,
                         format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it "can't create comment" do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question },
                        format: :js
        end.not_to change(Comment, :count)
      end
    end
  end
end
