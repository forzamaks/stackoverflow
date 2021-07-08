require 'rails_helper'

feature 'User can add links to answer', %{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url) {'https://google.com'}
  given(:url_2) {'https://test.com'}
  given(:gist_url) { 'https://gist.github.com/forzamaks/766c7ed8386ba3298d416098663ae260' }
  given(:gist_url_2) { 'https://gist.github.com/forzamaks/b9ae1d3a8b025df1e9d9c4532a804006' }
  given(:invalid_url) { 'tratata' }
  
  background do
    sign_in(user)
    visit question_path(question)

  end
  scenario 'User adds link when answer question', js: true do

    within '.new-answer' do
      fill_in 'Body', with: 'text text text'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: url

      click_on 'Answer'
    end
    within '.answer' do
      # save_and_open_page
      expect(page).to have_link 'My gist', href: url
    end
  end

  scenario 'User adds many links when answer question', js: true do

    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'add link'

    within '.nested-fields' do
      fill_in 'Link name', with: 'My gist 1'
      fill_in 'Url', with: url_2
    end

    click_on 'Answer'
    
    expect(page).to have_link 'My gist', href: url
    expect(page).to have_link 'My gist 1', href: url_2
  end

  scenario 'Invalid url address', js: true do
    within '.new-answer' do
      fill_in 'Body', with: 'text text text'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: invalid_url

      click_on 'Answer'
    end
    expect(page).to have_content 'Links url is invalid'
  end

  describe 'Edit answer' do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }
    scenario 'The author of the answer, when editing it, can add new links', js: true do

      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
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

  scenario 'User add link to gist when asks answer', js: true do

    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: gist_url

    click_on 'Answer'
    using_wait_time 10 do
      expect(page).to have_content 'My link'
      expect(page).to_not have_link 'My link', href: gist_url
    end
    
  end

  
end