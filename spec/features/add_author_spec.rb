require 'spec_helper'

feature "Add author" do
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin adds author successfully" do
    visit authors_path
    click_on 'New author'
    fill_in 'Firstname', with: 'John'
    fill_in 'Lastname', with: 'Tolkien'
    fill_in 'Biography', with: 'Some bio'
    click_on 'Create author'
    expect(page).to have_content 'Author was successfully created.'
    expect(page).to have_content "John Tolkien"
  end
end