require 'rails_helper'

feature 'User can delete own question', %q{
  In order to delete question
  As an authenticated User
  I'd like to be able to delete own question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:question_with_files) { create(:question, :with_files, user: user) }


  scenario 'Question owner tries to delete question' do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_content question.title

    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Other authorized user tries to delete question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Unauthorized user tries to delete question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Is author can delete attachments', js: true do
    sign_in(user)
    visit question_path(question_with_files)
    expect(page).to have_link question_with_files.filename
    click_on 'Delete attach'
    expect(page).to_not have_link question_with_files.filename
  end

  scenario 'Other authorized user can not delete attached files', js: true do
    sign_in(second_user)
    visit question_path(question_with_files)

    expect(page).to have_link question_with_files.filename
    expect(page).to_not have_link 'Delete attach'
  end
end