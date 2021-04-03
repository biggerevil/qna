# frozen_string_literal: true

require 'rails_helper'

describe 'User can log out', "
  In order to keep my account safe or change it
  As a user
  I'd like to be able to log out
" do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it 'User can log out' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
