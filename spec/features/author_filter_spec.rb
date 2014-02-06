require 'spec_helper'

feature "Author filter" do
  given!(:author) {FactoryGirl.create(:author)} #John Tolkien
  given!(:author2) {FactoryGirl.create(:author, firstname: 'Lev', lastname: 'Tolstoy')}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "War and Peace I", price: 20.00, in_stock: 0, author: author2, category: category)}
  before(:each) do
    visit '/books'
  end
  scenario "A customer can navigate books by categories" do
    click_on 'Filter by author'
    click_on 'John Tolkien'
    expect(page).to have_content book.title
    expect(page).to_not have_content book2.title
  end
end