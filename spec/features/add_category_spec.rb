require 'spec_helper'

feature "Add category" do
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "Admin adds category successfully" do
    visit categories_path
    click_on 'New category'
    fill_in 'Category title', with: 'Fantasy'
    click_on 'Create category'
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content "Fantasy"
  end
end