require 'spec_helper'

feature "Category filter" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category, title: 'Fantasy')}
  given!(:category2) {FactoryGirl.create(:category, title: 'Historic')}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "War and Peace I", price: 20.00, in_stock: 0, author: author, category: category2)}
  before(:each) do
    visit books_path
  end
  scenario "A customer can navigate books by categories" do
    click_on 'Filter by category'
    click_on 'Fantasy'
    expect(page).to have_content book.title
    expect(page).to_not have_content book2.title
  end
end