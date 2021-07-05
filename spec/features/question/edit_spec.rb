require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }


  scenario 'Unathenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edits has question', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        # expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his question with errors', js: true do
      sign_in(user)
      visit question_path(question)
      
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''

        click_on 'Save'
        expect(page).to have_content "Title can't be blank"
      end
    end
    scenario "tries to edit other user's question" do
      sign_in(second_user)
      visit question_path(question)

      expect(page).to have_content question.body
      expect(page).to_not have_link 'Edit question'
    end
  end
end