# frozen_string_literal: true

shared_examples_for 'API Linkable' do
  context 'links' do
    let!(:links) { create_list(:link, 2, linkable: linkable) }

    before do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it 'has links' do
      expect(linkable_response).to have_key('links')
    end

    it 'returns all public fields' do
      linkable.links.each_with_index do |link, i|
        %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
          expect(linkable_response['links'][i][attr]).to eq link.send(attr).as_json
        end
      end
    end
  end
end
