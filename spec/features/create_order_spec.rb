require 'spec_helper'

feature "Create order" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:country) {FactoryGirl.create(:country)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit book_path(book)
    click_on 'Add to cart'
    within '#cc' do 
      fill_in 'Card number', with: '12345678901234'
      fill_in 'CVV', with: '1234'
      fill_in 'Owner firstname', with: 'Firstname'
      fill_in 'Owner lastname', with: 'Lastname'
      fill_in 'Exp month', with: '1'
      fill_in 'Exp year', with: '2015'
    end
    within '#ba' do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    within '#sa' do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
  end

  scenario "A customer creates order successfully with valid data" do
    click_on 'Let me buy already!'
    expect(page).to have_content 'Order was successfully created.'
  end
end