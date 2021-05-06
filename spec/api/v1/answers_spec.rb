# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/:id/answers' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'] }
      let(:api_path) { '/api/v1/questions/' + question.id.to_s + '/answers' }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answers_response.first[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/answers/1' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, author: user) }
      let(:api_path) { '/api/v1/answers/' + answer.id.to_s }
      let(:answer_response) { json['answer'] }
      let(:method) { :get }

      it_behaves_like 'API Linkable' do
        let(:linkable) { answer }
        let(:linkable_response) { answer_response }
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { answer }
        let(:commentable_response) { answer_response }
      end

      it_behaves_like 'API Fileable' do
        let(:fileable) { answer }
        let(:fileable_response) { answer_response }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns json with key answer' do
        expect(json).to have_key('answer')
      end

      it 'returns all public fields' do
        %w[id body author created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { '/api/v1/questions/' + question.id.to_s + '/answers' }
    let(:method) { :post }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'with valid attributes' do
        it 'returns 200' do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          expect(response).to be_successful
        end

        it 'answer is created' do
          expect do
            post api_path,
                 params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          end.to change(Answer, :count).by(1)
        end

        it 'returns json with key answer' do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          expect(json).to have_key('answer')
        end

        it 'returns all public fields' do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          %w[id body author created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end

        context 'with invalid attributes' do
          it 'returns 200' do
            post api_path,
                 params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
            expect(response.status).to eq 422
          end

          it 'answer is not created' do
            expect do
              post api_path,
                   params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
            end.to change(Answer, :count).by(0)
          end

          it 'returns json with errors' do
            post api_path,
                 params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
            expect(json).to have_key('body')
            expect(json['body'].first).to eq "can't be blank"
          end
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:author) { create(:user) }
    let(:answer) { create(:answer, author: author) }
    let(:api_path) { '/api/v1/answers/' + answer.id.to_s }
    let(:method) { :patch }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let(:answer_response) { json['answer'] }

      context 'with valid attributes' do
        it 'returns 200' do
          patch api_path,
                params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          expect(response).to be_successful
        end

        it 'answer is updated' do
          patch api_path,
                params: { access_token: access_token.token, answer: { body: 'New body' } }, headers: headers
          answer.reload
          expect(answer.body).to eq 'New body'
        end

        it 'returns json with key answer' do
          patch api_path,
                params: { access_token: access_token.token, answer: { body: 'New body' } }, headers: headers
          expect(json).to have_key('answer')
        end

        it 'returns all public fields' do
          patch api_path,
                params: { access_token: access_token.token, answer: { body: 'New body' } }, headers: headers
          %w[id body author created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'returns 422' do
          patch api_path, params: { access_token: access_token.token, answer: { body: '' } },
                          headers: headers
          expect(response.status).to eq 422
        end

        it 'answer is not updated' do
          patch api_path, params: { access_token: access_token.token, answer: { body: '' } },
                          headers: headers
          answer.reload
          expect(answer.body).not_to eq ''
        end

        it 'returns json with errors' do
          patch api_path, params: { access_token: access_token.token, answer: { body: '' } },
                          headers: headers
          expect(json).to have_key('body')
          expect(json['body'].first).to eq "can't be blank"
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:method) { :delete }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/answers/:id' }
    end

    context 'authorized' do
      let(:author) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, author: author) }
      let(:api_path) { '/api/v1/answers/' + answer.id.to_s }

      context 'author' do
        it 'returns 200' do
          delete api_path, params: { access_token: access_token.token }
          expect(response).to be_successful
        end

        it 'answer is deleted' do
          expect do
            delete api_path, params: { access_token: access_token.token }
          end.to change(Answer, :count).by(-1)
        end
      end

      context 'not author' do
        let(:not_author) { create(:user) }
        let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }
        let(:author) { create(:user) }
        let!(:answer) { create(:answer, author: author) }
        let(:api_path) { '/api/v1/answers/' + answer.id.to_s }

        it 'answer is not deleted' do
          expect do
            delete api_path, params: { access_token: not_author_access_token.token }
          end.to change(Answer, :count).by(0)
        end
      end
    end
  end
end
