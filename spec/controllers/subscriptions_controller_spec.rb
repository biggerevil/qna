# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'authenticated' do
      before { sign_in(user) }

      it 'returns http success' do
        post :create, params: { question_id: question.id, user: user }, format: :js
        expect(response).to have_http_status(:success)
      end

      it 'creates subscription' do
        expect do
          post :create, params: { question_id: question.id, user: user }, format: :js
        end.to change(Subscription, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id, user: user }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'unauthenticated' do
      it 'returns http unauthorized' do
        post :create, params: { question_id: question.id, user: user }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end

      it "doesn't create subscription" do
        expect do
          post :create, params: { question_id: question.id, user: user }, format: :js
        end.to change(Subscription, :count).by(0)
      end

      it "doesn't render create view" do
        post :create, params: { question_id: question.id, user: user }, format: :js
        expect(response).not_to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authenticated' do
      before { sign_in(user) }

      it 'returns http success' do
        delete :destroy, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(:success)
      end

      it 'deletes subscription' do
        expect do
          delete :destroy, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { question_id: question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'unauthenticated' do
      it 'returns http unauthorized' do
        delete :destroy, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end

      it 'deletes subscription' do
        expect do
          delete :destroy, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by(0)
      end

      it "doesn't render destroy view" do
        delete :destroy, params: { question_id: question.id }, format: :js
        expect(response).not_to render_template :destroy
      end
    end
  end
end
