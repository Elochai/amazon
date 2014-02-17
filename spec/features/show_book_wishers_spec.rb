require 'spec_helper'

feature "Show book wishers" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  before(:each) do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit edit_customer_registration_path
    visit book_path(book)
  end

  scenario "A customer can see list of book wishers" do
    click_on "Add to wish list"
    click_on "Show book wishers"
    expect(page).to have_content "user@gmail.com"
  end
end