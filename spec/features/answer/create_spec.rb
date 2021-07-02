require 'rails_helper'

feature 'User can create answer', %q{
  An authenticated user
  can leave an answer 
  to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit question_path(question)

    end
    scenario 'answer the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer'
  
      expect(page).to have_content 'You answer successfully created.'
      expect(page).to have_content 'text text text'
    end
    scenario 'answer the question with errors' do
      click_on 'Answer'
  
      expect(page).to have_content "Body can't be blank"
    end
  end
  
  scenario 'Unauthenticated user tried to answer the question' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end