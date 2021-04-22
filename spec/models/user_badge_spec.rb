# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:badge) }
end
