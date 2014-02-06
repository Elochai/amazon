require 'spec_helper'

feature "Add book" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}
  given!(:book) {FactoryGirl.create(:book, author: author, category: category)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin deletes books successfully" do
    visit book_path(book)
    click_on 'Delete book'
    expect(page).to have_content 'Book was successfully deleted.'
    expect(page).to_not have_content book.title
  end
end