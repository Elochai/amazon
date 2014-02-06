require 'spec_helper'

feature "Clear cart" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 1, author: author, category: category)}

  scenario "A customer deletes all book from cart successfully by pressing 'Clear shopping cart' button" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit book_path(book)
    click_on 'Add to cart'
    visit book_path(book2)
    click_on 'Add to cart'
    click_on 'Clear shopping cart'
    expect(page).to_not have_content book.title
    expect(page).to_not have_content book2.title
    expect(customer.order_items.load.count).to eq(0) 
    expect(page).to have_content 'Your cart is epmty.'
  end
end