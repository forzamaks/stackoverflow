require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to registration
} do

  given(:user) { create(:user)  }

  background { visit new_user_registration_path }

  scenario 'Registration new user' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end