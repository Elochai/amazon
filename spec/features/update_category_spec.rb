require 'spec_helper'

feature "Update book" do
  given!(:category) {FactoryGirl.create(:category)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "Admin updates category successfully" do
    visit category_path(category)
    click_on 'Edit category info'
    fill_in 'Category title', with: 'New title'
    click_on 'Update category'
    expect(page).to have_content 'Category was successfully updated.'
    expect(page).to have_content 'New title'
    expect(page).to_not have_content category.title
  end
end