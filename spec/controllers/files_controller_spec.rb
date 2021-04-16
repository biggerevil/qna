# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')
    end

    context 'Author' do
      before { sign_in(author) }

      it 'deletes attachment' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      before { sign_in(second_user) }

      it "doesn't delete attachment" do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(question.files, :count).by(0)
      end

      it 'response has 403 http status' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
