# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:question) { create(:question) }
      let(:question_response) { json['question'] }
      let(:api_path) { '/api/v1/questions/' + question.id.to_s }

      it_behaves_like 'API Linkable' do
        let(:linkable) { question }
        let(:linkable_response) { question_response }
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { question }
        let(:commentable_response) { question_response }
      end

      it_behaves_like 'API Fileable' do
        let(:fileable) { question }
        let(:fileable_response) { question_response }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns json with key question' do
        expect(json).to have_key('question')
      end

      it 'returns all public fields' do
        %w[id title body author created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        it 'new question is created' do
          expect do
            post api_path,
                 params: { access_token: access_token.token, question: attributes_for(:question) }
          end.to change(Question, :count).by(1)
        end

        it 'returns 200' do
          post api_path,
               params: { access_token: access_token.token, question: attributes_for(:question) }
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          post api_path,
               params: { access_token: access_token.token, question: attributes_for(:question) }
          %w[id title body author created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'new question is not created' do
          expect do
            post api_path,
                 params: { access_token: access_token.token,
                           question: attributes_for(:question, :invalid) }
          end.to change(Question, :count).by(0)
        end

        it 'returns 422' do
          post api_path,
               params: { access_token: access_token.token,
                         question: attributes_for(:question, :invalid) }
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          post api_path,
               params: { access_token: access_token.token,
                         question: attributes_for(:question, :invalid) }
          expect(json).to have_key('title')
          expect(json['title'].first).to eq "can't be blank"
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:method) { :patch }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions/:id' }
    end

    context 'authorized' do
      let(:author) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let!(:question) { create(:question, author: author) }
      let(:api_path) { '/api/v1/questions/' + question.id.to_s }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        it 'returns 200' do
          patch api_path,
                params: { access_token: access_token.token, question: { body: 'New body' } }
          expect(response).to be_successful
        end

        it 'question is updated' do
          patch api_path,
                params: { access_token: access_token.token, question: { body: 'New body' } }
          question.reload
          expect(question.body).to eq 'New body'
        end

        it 'returns all public fields' do
          patch api_path,
                params: { access_token: access_token.token, question: { body: 'New body' } }
          %w[id title body author created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'question is not updated' do
          expect do
            patch api_path,
                  params: { access_token: access_token.token,
                            question: attributes_for(:question, :invalid) }
          end.to change(Question, :count).by(0)
        end

        it 'returns 422' do
          patch api_path,
                params: { access_token: access_token.token,
                          question: attributes_for(:question, :invalid) }
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          patch api_path,
                params: { access_token: access_token.token,
                          question: attributes_for(:question, :invalid) }
          expect(json).to have_key('title')
          expect(json['title'].first).to eq "can't be blank"
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:method) { :delete }
    let(:headers) { nil }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions/:id' }
      let(:question_response) { json['question'] }
    end

    context 'authorized' do
      let(:author) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }
      let!(:question) { create(:question, author: author) }
      let(:api_path) { '/api/v1/questions/' + question.id.to_s }

      context 'author' do
        it 'returns 200' do
          delete api_path,
                 params: { access_token: access_token.token, question: { body: 'New body' } }
          expect(response).to be_successful
        end

        it 'question is deleted' do
          expect do
            delete api_path,
                   params: { access_token: access_token.token, question: { body: 'New body' } }
          end.to change(Question, :count).by(-1)
        end
      end

      context 'not author' do
        let(:not_author) { create(:user) }
        let(:not_author_access_token) { create(:access_token, resource_owner_id: not_author.id) }
        let(:author) { create(:user) }
        let!(:question) { create(:question, author: author) }

        it 'question is not deleted' do
          expect do
            delete api_path,
                   params: { access_token: not_author_access_token.token, question: question }
          end.to change(Question, :count).by(0)
        end
      end
    end
  end
end
