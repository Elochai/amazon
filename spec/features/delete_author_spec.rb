require 'spec_helper'

feature "Delete author" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin deletes author successfully" do
    visit author_path(author)
    click_on 'Delete author'
    expect(page).to have_content 'Author was successfully deleted.'
    expect(page).to_not have_content author.full_name
  end
end