# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }
end
