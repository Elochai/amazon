require 'spec_helper'

feature "Show all books" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 0, author: author, category: category)}
  before(:each) do
    visit '/books'
  end
  scenario "Shows all book titles in index view" do
    expect(page).to have_content book.title
    expect(page).to have_content book2.title
  end
  scenario "Shows all book prices in index view" do
    expect(page).to have_content book.price
    expect(page).to have_content book2.price
  end
  scenario "Shows all book in_stock values in index view" do
    expect(page).to have_content book.in_stock
    expect(page).to have_content book2.in_stock
  end
  scenario "Shows all book authors full names in index view" do
    expect(page).to have_content book.author.full_name
  end
  scenario "Shows all book categories in index view" do
    expect(page).to have_content book.category.title
  end
end