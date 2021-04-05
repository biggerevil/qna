# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:author) { create(:user) }

  before { sign_in(author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 're-renders question' do
        post :create,
             params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author, question: question) }

    context 'Author' do
      it 'deletes answer from database' do
        expect do
          delete :destroy,
                 params: { id: answer, question_id: question }
        end.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy,
               params: { id: answer, question_id: question }
        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it 'deletes answer from database' do
        expect do
          delete :destroy,
                 params: { id: answer, question_id: question }
        end.not_to change(question.answers, :count)
      end

      it 'redirects to question' do
        delete :destroy,
               params: { id: answer, question_id: question }
        expect(response).to redirect_to(question_path(answer.question))
      end
    end
  end
end
