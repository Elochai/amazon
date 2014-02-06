require 'spec_helper'

feature "Add book" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin adds book successfully" do
    visit books_path
    click_on 'New book'
    fill_in 'Book title', with: 'LOTR'
    fill_in 'Price', with: '10.99'
    fill_in 'Number in stock', with: '2'
    select 'John Tolkien', from: 'Author'
    select 'Fantasy', from: 'Category'
    fill_in 'Book description', with: 'Some description'
    click_on 'Create book'
    expect(page).to have_content 'Book was successfully created.'
    expect(page).to have_content "LOTR"
  end
end