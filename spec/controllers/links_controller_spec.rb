# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:link) { create(:link, linkable: question) }

    context 'Author' do
      before { sign_in(author) }

      it 'deletes link' do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it "doesn't delete link" do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.to change(Link, :count).by(0)
      end

      it 'response has 403 http status' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
