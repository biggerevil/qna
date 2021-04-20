# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe '#is_gist?' do
    let(:gist_url) { 'https://gist.github.com/biggerevil/dd356cdb2c99455b4646f4a3a6c2cad7' }
    let(:question) { create(:question) }
    let(:gist_link) { create(:link, linkable: question, url: gist_url) }
    let(:not_gist_link) { create(:link, linkable: question, url: 'https://google.com') }

    it 'Returns true for gist link' do
      expect(gist_link).to be_is_gist
    end

    it 'Returns false for not gist link' do
      expect(not_gist_link).not_to be_is_gist
    end
  end
end
