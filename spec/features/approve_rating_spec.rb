require 'spec_helper'

feature "Approve rating" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:admin) {FactoryGirl.create(:customer, email: 'admin@gmail.com', admin: true)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:rating) {FactoryGirl.create(:rating, book: book, approved: false, customer: customer, rating: 10, text: 'Awesome!')}
  given!(:book) {FactoryGirl.create(:book, author: author, category: category)}
  before(:each) do
    visit new_customer_session_path
    fill_in 'Email', with: 'admin@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit book_path(book)
  end

  scenario "An admin can approve ratings" do
    click_on 'Approve this review'
    expect(page).to have_content rating.text
    expect(page).to have_content rating.rating
    expect(page).to_not have_content 'Review by ' + customer.email.to_s + ' should be approved first'
  end
end