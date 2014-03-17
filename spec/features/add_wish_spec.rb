require 'spec_helper'
require 'features_spec_helper'
feature "Add wish" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  before(:each) do
    sign_in_that customer
    visit book_path(book)
  end

  scenario "A customer can add book to wish list" do
    click_on "Add to wish list"
    expect(page).to have_content "Book was successfully added to wish list."
    expect(page).to have_content "Remove from wish list"
    expect(page).to_not have_content "Add to wish list"
  end
  scenario "A visitor can not add book to wish list" do
    click_on "Sign out"
    visit book_path(book)
    click_on "Add to wish list"
    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(page).to have_content "Sign in"
  end
end