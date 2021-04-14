# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  before { sign_in(author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) },
                      format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders create template' do
        post :create,
             params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: author) }

    context 'Author' do
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) },
                           format: :js
          end.not_to change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) },
                         format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it 'does not change answer attributes' do
        old_body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' } },
                       format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'response has 403 http status' do
        patch :update, params: { id: answer, answer: { body: 'new body' } },
                       format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author, question: question) }

    context 'Author' do
      it 'deletes answer from database' do
        expect do
          delete :destroy,
                 params: { id: answer, question_id: question }, format: :js
        end.to change(question.answers, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy,
               params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it 'deletes answer from database' do
        expect do
          delete :destroy,
                 params: { id: answer, question_id: question }, format: :js
        end.not_to change(question.answers, :count)
      end

      it 'response has 403 http status' do
        delete :destroy,
               params: { id: answer, question_id: question }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #make_best' do
    let(:first_answer) { create(:answer, author: author, question: question) }
    let(:second_answer) { create(:answer, author: author, question: question) }

    context 'Author' do
      it 'makes best' do
        patch :make_best, params: { id: first_answer }, format: :js
        first_answer.reload

        expect(first_answer.is_best).to be_truthy
      end

      it 'makes previous not best' do
        first_answer.update!(is_best: true)

        patch :make_best, params: { id: second_answer }, format: :js
        second_answer.reload
        first_answer.reload

        expect(second_answer.is_best).to be_truthy
        expect(first_answer.is_best).to be_falsey
      end

      it 'renders template make_best' do
        patch :make_best, params: { id: first_answer }, format: :js
        expect(response).to render_template :make_best
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it "doesn't make best" do
        patch :make_best, params: { id: first_answer }, format: :js
        first_answer.reload

        expect(first_answer.is_best).to be_falsey
      end

      it 'response has 403 http status' do
        patch :make_best, params: { id: first_answer }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
