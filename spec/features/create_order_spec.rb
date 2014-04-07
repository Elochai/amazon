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
    Order.last.set_step! 2
    visit new_address_path
    within "#ba" do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    within "#sa" do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    click_on 'Save and continue'
    expect(page).to have_content 'Addresses was successfully added.'
  end

  scenario "A customer chooses delivery then" do
    delivery = FactoryGirl.create :delivery, name: "Delivery", price: 15
    Order.last.set_step! 3
    visit order_delivery_path
    choose("delivery_id_" + "#{delivery.id}")
    click_on 'Save and continue'
    expect(page).to have_content 'Delivery was successfully added to order.'
  end

  context 'Credit card and confirm steps' do
    before do
      FactoryGirl.create :credit_card, order_id: Order.last.id
      delivery = FactoryGirl.create :delivery
      Order.last.update(delivery_id: delivery.id)
      FactoryGirl.create :bill_address, order_id: Order.last.id, country_id: country.id
      FactoryGirl.create :ship_address, order_id: Order.last.id, country_id: country.id
    end

    scenario "A customer adds credit_card info then" do
      Order.last.set_step! 4
      visit new_credit_card_path
      fill_in 'Card number', with: '12345678901234'
      fill_in 'CVV', with: '1234'
      fill_in 'Owner firstname', with: 'Firstname'
      fill_in 'Owner lastname', with: 'Lastname'
      if Time.now.month == 12
        select "1", from: 'Exp month'
      else
        select "#{Time.now.month+1}", from: 'Exp month'
      end
      select "#{Time.now.year+2}", from: 'Exp year'
      click_on 'Save and continue'
      expect(page).to have_content 'Credit card was successfully added to order.'
    end

    scenario "A customer confirm changes then and creates his order, if he signed in" do
      Order.last.set_step! 5
      visit order_confirm_path
      visit new_customer_session_path
      fill_in 'Email', with: customer.email
      fill_in 'Password', with: customer.password
      click_button 'Sign in'
      click_on 'Place order'
      expect(page).to have_content 'Order was successfully created, wait for call from our shipping department, thanks!'
    end

    scenario "A customer cannot create his order, if he not signed in" do
      Order.last.set_step! 5
      visit order_confirm_path
      click_on 'Place order'
      expect(page).to_not have_content 'Order was successfully created, wait for call from our shipping department, thanks!'
      expect(page).to have_content 'Sign in'
    end
  end
end