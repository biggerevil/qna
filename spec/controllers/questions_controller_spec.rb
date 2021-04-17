# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:user) }

  before { sign_in(author) }

  describe 'GET #new' do
    it 'question has links created' do
      get :new
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question, author: author) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, author: author) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(controller.question).to eq question
      end

      it 'changes question attributes' do
        patch :update,
              params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) },
                       format: :js
      end

      it 'does not change question' do
        title = question.title
        body = question.body

        question.reload

        expect(question.title).to eq title
        expect(question.body).to eq body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it "can't update question" do
        old_question_body = question.body
        old_question_title = question.title
        patch :update,
              params: { id: question, question: { title: 'another title', body: 'updated body' } }, format: :js
        question.reload

        expect(question.title).to eq old_question_title
        expect(question.body).to eq old_question_body
      end

      it 'returns 403 http status' do
        patch :update,
              params: { id: question, question: { title: 'updated title', body: 'updated body' } }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: author) }

    context 'Author' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(question_path(question))
      end
    end
  end
end
