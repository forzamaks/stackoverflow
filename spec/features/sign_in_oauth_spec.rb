require 'rails_helper'

feature 'Authorization from providers', %q{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  given!(:user) { create(:user, email: 'test@test.com')}
  background { visit new_user_session_path }

  describe 'Sign in with GitHub' do
    scenario 'sign in user' do
      mock_auth_hash(:github, 'user@test.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth_hash(:github)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Email'
      fill_in 'Email', with: 'user@test.com'
      click_on 'Submit'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'sign in user' do
      mock_auth_hash(:vkontakte, 'user@test.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Email'
      fill_in 'Email', with: 'user@test.com'
      click_on 'Submit'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'user enters incorrect email' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Email'
      fill_in 'Email', with: 'wrong_email'
      click_on 'Submit'

      expect(page).to have_content 'Email'
      expect(page).to have_selector("input[type=submit][value='Submit']")
    end
  end
end 