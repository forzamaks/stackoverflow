require 'rails_helper'

feature 'The author can choose the best answer', "
  As the author of the question
  I would like to choose the best answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }

  

  scenario 'Unauthenticated cannot mark the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user' do
    scenario 'Can mark the best answer if user owner of the question', js: true do
      sign_in(user)
      visit question_path(question)

      within ".answer[data-answer-id='#{answer.id}']" do
        expect(page).not_to have_content 'Best'
        click_on 'Mark as favorite'
        expect(page).to have_content 'Best'
      end
    end

    scenario 'Cannot mark the best answer if user not owner of the question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Mark as favorite'
    end
  end
end