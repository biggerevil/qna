# frozen_string_literal: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
", js: true do
  let(:user) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    let(:gists_url) { 'https://gist.github.com/biggerevil/dd356cdb2c99455b4646f4a3a6c2cad7' }

    it 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    it 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    it 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'Files',
                  ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'asks a question with gist link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Name', with: 'Gist'
      fill_in 'Url', with: gists_url

      click_on 'Ask'

      expect(page).to have_link 'Gist', href: gists_url
      expect(page).to have_content 'me am gist'
    end

    describe 'asks a question and creates badge' do
      it 'without errors' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Badge title', with: 'Badge title for you'
        attach_file 'Image', "#{Rails.root}/spec/support/image.jpg"

        click_on 'Ask'

        expect(page).to have_link 'Reward image'
        expect(page).to have_content 'Badge title'
      end

      it 'with blank title' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        attach_file 'Image', "#{Rails.root}/spec/support/image.jpg"

        click_on 'Ask'

        expect(page).to have_content "Badge title can't be blank"
      end

      it 'with blank image' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Badge title', with: 'Badge title for you'

        click_on 'Ask'

        expect(page).to have_content "Badge image can't be blank"
      end
    end

    describe 'Multiple sessions' do
      it 'Another user can see created question without reloading', js: true do
        Capybara.using_session('another_user') do
          visit questions_path
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path

          click_on 'Ask question'
          fill_in 'Title', with: 'Question of user'
          fill_in 'Body', with: 'Body of question'
          click_on 'Ask'

          expect(page).to have_content 'Your question was successfully created'
          expect(page).to have_content 'Question of user'
          expect(page).to have_content 'Body of question'
        end

        Capybara.using_session('another_user') do
          expect(page).to have_content 'Question of user'
        end
      end
    end
  end

  it 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
