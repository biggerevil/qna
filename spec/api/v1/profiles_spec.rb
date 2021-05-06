# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:current_user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }
    let!(:users) { create_list(:user, 2) }
    let(:json_response) { json['users'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    before do
      get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
    end

    it 'returns all users except for authenticated' do
      expect(json_response.size).to eq users.size
    end

    it 'returns all public fields' do
      users.each_with_index do |user, i|
        %w[id email admin created_at updated_at].each do |attr|
          expect(json_response[i][attr]).to eq user.send(attr).as_json
        end
      end
    end

    it "doesn't return private fields" do
      (0...json_response.size).each do |i|
        %w[password encrypted_password].each do |attr|
          expect(json_response[i]).not_to have_key(attr)
        end
      end
    end

    it "doesn't return current_user" do
      json_response.each do |user_json|
        expect(user_json['id']).not_to eq current_user.id
      end
    end
  end
end
