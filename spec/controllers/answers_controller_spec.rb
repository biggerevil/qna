# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

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

      it 're-renders new view' do
        post :create,
             params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
