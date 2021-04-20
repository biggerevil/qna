# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to belong_to(:question) }

  it 'has one attached file' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
