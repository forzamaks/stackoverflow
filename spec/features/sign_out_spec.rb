require 'rails_helper'

feature 'User can sign out', %q{
  An authorized user
  has the ability to log out
} do
  given(:user) { create(:user) }

  scenario 'Authorized user can logout' do
    sign_in(user)
    visit root_path
    expect(page).to have_content 'Log out'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end