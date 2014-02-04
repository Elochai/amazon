require 'spec_helper'

feature "Delete book from cart" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}

  scenario "Deletes successfully by pressing 'Delete from cart' button" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit book_path(book)
    click_on 'Add to cart'
    click_on 'Delete from cart'
    expect(page).to_not have_content book.title
    expect(customer.order_items.load.count).to eq(0) 
  end
end