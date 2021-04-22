# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user, badges: create_list(:badge, 3)) }

    before do
      sign_in(user)
      get :index
    end

    it 'returns http success' do
      expect(response).to render_template :index
    end

    it 'assigns all user badges to @badges' do
      expect(assigns(:badges)).to eq user.badges
    end
  end
end
