require 'spec_helper'

feature "Show all categories" do
  given!(:category) {FactoryGirl.create(:category)}
  given!(:category2) {FactoryGirl.create(:category, title: "Historic")}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 0, category: category)}
  before(:each) do
    visit categories_path
  end
  scenario "A customer can see all category names in index view" do
    expect(page).to have_content category.title
    expect(page).to have_content category2.title
  end
  scenario "A customer can see number of books in each category in index view" do
    expect(page).to have_content category.number_of_books
    expect(page).to have_content category2.number_of_books
  end
end