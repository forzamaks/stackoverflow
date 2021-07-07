require 'rails_helper'

feature 'User can delete own answer', %q{
  As an authenticated User
  I'd like to be able to delete own answer
} do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:answer_with_files) { create(:answer, :with_file, question: question, user: user) }


  scenario 'Answer owner tries to delete answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body

    click_on 'Delete answer'
    expect(page).to_not have_content answer.body  
  end

  scenario 'Other authorized user tries to delete answer', js: true do
    sign_in(second_user)
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthorized user tries to delete answer', js: true do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Is author can delete attachments', js: true do
    sign_in(user)
    visit question_path(answer_with_files.question)
    expect(page).to have_link answer_with_files.filename
    click_on 'Delete attach'
    expect(page).to_not have_link answer_with_files.filename
  end

  scenario 'Other authorized user can not delete attached files', js: true do
    sign_in(second_user)
    visit question_path(answer_with_files.question)

    expect(page).to have_link answer_with_files.filename
    expect(page).to_not have_link 'Delete attach'
  end
end