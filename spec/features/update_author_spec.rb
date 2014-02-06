require 'spec_helper'

feature "Update author" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "Admin updates author successfully" do
    visit author_path(author)
    click_on 'Edit author info'
    fill_in 'Firstname', with: 'Lev'
    fill_in 'Lastname', with: 'Tolstoy'
    fill_in 'Biography', with: 'Some NEW bio'
    click_on 'Update author'
    expect(page).to have_content 'Author was successfully updated.'
    expect(page).to have_content 'Lev Tolstoy'
    expect(page).to_not have_content author.full_name
  end
end