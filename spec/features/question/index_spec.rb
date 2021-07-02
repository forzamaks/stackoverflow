require 'rails_helper'

feature 'User can view questions list', %q{
  In order to get answer to my ploblem
  As any User
  I want to be able to view questions list
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  background do
    visit questions_path
  end

  scenario 'Authenticate user can view questions list' do
    sign_in(user)

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Unauthenticate user can view questions list' do

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end