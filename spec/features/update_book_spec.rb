require 'spec_helper'

feature "Update book" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:author2) {FactoryGirl.create(:author, firstname: 'Lev', lastname: 'Tolstoy')}
  given!(:category2) {FactoryGirl.create(:category, title: 'Historic')}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}
  given!(:book) {FactoryGirl.create(:book, author: author, category: category)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "An admin updates book successfully" do
    visit book_path(book)
    click_on 'Edit book info'
    fill_in 'Book title', with: 'New title'
    fill_in 'Price', with: '20.99'
    fill_in 'Number in stock', with: '5'
    select 'Lev Tolstoy', from: 'Author'
    select 'Historic', from: 'Category'
    fill_in 'Book description', with: 'Some NEW description'
    click_on 'Update book'
    expect(page).to have_content 'Book was successfully updated.'
    expect(page).to have_content 'New title'
    expect(page).to_not have_content book.title
  end
end