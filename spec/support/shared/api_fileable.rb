# frozen_string_literal: true

shared_examples_for 'API Fileable' do
  context 'files' do
    before do
      fileable.files.attach(io: File.open(Rails.root.join('spec/support', 'image.jpg')),
                            filename: 'image.jpg')
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it 'returns files' do
      expect(fileable_response['files'].size).to eq fileable.files.size
    end
  end
end
