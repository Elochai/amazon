require 'spec_helper'
require 'features_spec_helper'
feature "Remove wish" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  before(:each) do
    sign_in_that customer
    visit edit_customer_registration_path
    visit book_path(book)
  end

  scenario "A customer can remove book from wish list" do
    click_on "Add to wish list"
    click_on "Remove from wish list"
    expect(page).to have_content "Book was successfully deleted from wish list."
    expect(page).to_not have_content "Remove from wish list"
    expect(page).to have_content "Add to wish list"
  end
end