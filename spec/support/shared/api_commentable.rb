# frozen_string_literal: true

shared_examples_for 'API Commentable' do
  context 'comments' do
    let!(:comments) { create_list(:comment, 2, commentable: commentable, user: user) }

    before do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it 'has comments' do
      expect(commentable_response).to have_key('comments')
    end

    it 'returns all public fields' do
      commentable.comments.each_with_index do |comment, i|
        %w[id body user_id commentable_type commentable_id created_at updated_at].each do |attr|
          expect(commentable_response['comments'][i][attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end
end
