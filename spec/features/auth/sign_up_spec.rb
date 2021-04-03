# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign up', "
  In order to create account
  As a user
  I'd like to be able to sign up
" do
  let(:user) { create(:user) }

  before { visit new_user_registration_path }

  it 'User signs up with not taken email' do
    fill_in 'Email', with: 'right@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content 'You have signed up successfully.'
  end

  it 'User tries to sign up with taken email' do
    fill_in 'Email', with: user.email

    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
