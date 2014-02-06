require 'spec_helper'

feature "Delete category" do
  given!(:category) {FactoryGirl.create(:category)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin deletes category successfully" do
    visit category_path(category)
    click_on 'Delete category'
    expect(page).to have_content 'Category was successfully deleted.'
    expect(page).to_not have_content category.title
  end
end