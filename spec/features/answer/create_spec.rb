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
    scenario 'answer the question', js: true do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer'
  
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end
    scenario 'answer the question with errors', js: true do
      click_on 'Answer'
  
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer the question with attached files', js: true do
      fill_in 'Body', with: 'text text text2'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
  
  scenario 'Unauthenticated user tried to answer the question' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end