require 'spec_helper'

feature "Show category info" do
  given!(:category) {FactoryGirl.create(:category)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 0, category: category)}
  before(:each) do
    visit category_path(category)
  end

  scenario "A customer can see category title in show view" do
    expect(page).to have_content category.title
  end
  scenario "A customer can see category number of books in show view" do
    expect(page).to have_content category.number_of_books
  end
  scenario "A customer can see category books in show view" do
    expect(page).to have_content book.title
    expect(page).to have_content book2.title
  end
end