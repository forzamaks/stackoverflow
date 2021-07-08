require 'rails_helper'

feature 'User can add links to question', %{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url) {'https://google.com'}
  given(:url_2) {'https://test.com'}
  given(:gist_url) { 'https://gist.github.com/forzamaks/766c7ed8386ba3298d416098663ae260' }
  given(:gist_url_2) { 'https://gist.github.com/forzamaks/b9ae1d3a8b025df1e9d9c4532a804006' }
  given(:invalid_url) { 'tratata' }
  given(:question) { create(:question, user: user) }


  describe 'Add links to new question' do
    background do
      sign_in(user)
      visit new_question_path
    end
    scenario 'User adds link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: url
  
      click_on 'Ask'
  
      expect(page).to have_link 'My gist', href: url
    end
  
    scenario 'User adds many links when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: url
  
      click_on 'add link'
  
      within '.nested-fields' do
        fill_in 'Link name', with: 'My gist 1'
        fill_in 'Url', with: url_2
      end
  
      click_on 'Ask'
      
      expect(page).to have_link 'My gist', href: url
      expect(page).to have_link 'My gist 1', href: url_2
    end
  
    scenario 'Invalid url address', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: invalid_url
  
      click_on 'Ask'
  
      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'User add link to gist when asks question', js: true do
  
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'gist'
      fill_in 'Url', with: gist_url
  
      click_on 'Ask'
  
      expect(page).to_not have_link 'gist', href: gist_url
    end
  end
  

  scenario 'The author of the question, when editing it, can add new links', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_on 'Edit question'

      fill_in 'Title', with: 'edited question title'
      fill_in 'Body', with: 'edited question body'

      click_on 'add link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'My gist 1'
        fill_in 'Url', with: url_2
      end

      click_on 'Save'
    end
    expect(page).to have_link 'My gist 1', href: url_2


  end
end