# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:destroy) }

  describe 'Testing author_of? method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    context 'Author' do
      it 'Returns true' do
        expect(user.author_of?(question)).to be_truthy
      end
    end

    context 'Not author' do
      let(:second_user) { create(:user) }

      it 'Returns false' do
        expect(second_user.author_of?(question)).to be_falsey
      end
    end
  end
end
