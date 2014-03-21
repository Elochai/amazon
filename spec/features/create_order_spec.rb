require 'spec_helper'
require 'features_spec_helper'
feature "Create order" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:country) {FactoryGirl.create(:country)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}

  before do 
    visit book_path(book)
    click_on 'Add to cart'
  end

  scenario "A customer add book to cart first" do
    expect(page).to have_content 'Book was successfully added to cart.'
  end
  scenario "A customer adds addresses info then" do
    fill_addresses
    expect(page).to have_content 'Addresses was successfully added.'
  end
  scenario "A customer chooses delivery then" do
    choose_delivery
    expect(page).to have_content 'Delivery was successfully added to order.'
  end
  scenario "A customer adds credit_card info then" do
    fill_credit_card
    expect(page).to have_content 'Credit card was successfully added to order.'
  end
  scenario "A customer confirm changes then and creates his order, if he signed in" do
    fill_credit_card
    sign_in_that customer
    visit order_items_path
    click_on 'Place order'
    expect(page).to have_content 'Order was successfully created, wait for call from our shipping department, thanks!'
  end
  scenario "A customer cannot create his order, if he not signed in" do
    fill_credit_card
    click_on 'Place order'
    expect(page).to_not have_content 'Order was successfully created, wait for call from our shipping department, thanks!'
    expect(page).to have_content 'Sign in'
  end
end