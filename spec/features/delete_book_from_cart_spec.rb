require 'spec_helper'
require 'features_spec_helper'
feature "Delete book from cart" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}

  scenario "A customer deletes successfully by pressing 'Delete from cart' button" do
    visit book_path(book)
    click_on 'Add to cart'
    click_on 'Remove from cart'
    expect(page).to_not have_content book.title
    expect(customer.order_items.load.count).to eq(0) 
    expect(page).to have_content 'Your cart is empty...'
  end
end