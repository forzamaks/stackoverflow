require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unathenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits has answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors', js: true do
      sign_in(user)
      visit question_path(question)
      
      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''

        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end
    scenario "tries to edit other user's question" do
      sign_in(second_user)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit'
    end
  end
end