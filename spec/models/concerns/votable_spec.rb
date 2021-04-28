# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let(:model) { described_class.to_s.downcase }
  let(:votable) { create(model) }
  let!(:upvotes) { create_list(:vote, 3, votable: votable, value: 1, user: create(:user)) }
  let!(:downvotes) { create_list(:vote, 2, votable: votable, value: -1, user: create(:user)) }

  it '#rating' do
    expect(votable.rating).to eq(1)
  end
end
