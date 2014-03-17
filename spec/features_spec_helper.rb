def fill_bill_address 
  click_on 'Save and continue'
  select 'Ukraine', from: 'Country'
  fill_in 'City', with:'Dnipropetrovsk'
  fill_in 'Address', with:'Some address'
  fill_in 'Zip code', with:'12345'
  fill_in 'Phone', with:'0671111111'
  click_on 'Save and continue'
end

def fill_ship_address
  fill_bill_address 
  select 'Ukraine', from: 'Country'
  fill_in 'City', with:'Dnipropetrovsk'
  fill_in 'Address', with:'Some address'
  fill_in 'Zip code', with:'12345'
  fill_in 'Phone', with:'0671111111'
  click_on 'Save and continue'
end

def choose_delivery
  delivery = FactoryGirl.create :delivery, name: "Delivery", price: 15
  fill_ship_address
  choose("delivery_id_" + "#{delivery.id}")
  click_on 'Save and continue'
end

def fill_credit_card
  choose_delivery
  fill_in 'Card number', with: '12345678901234'
  fill_in 'CVV', with: '1234'
  fill_in 'Owner firstname', with: 'Firstname'
  fill_in 'Owner lastname', with: 'Lastname'
  fill_in 'Exp month', with: '1'
  fill_in 'Exp year', with: '2015'
  click_on 'Save and continue'
end

def sign_in_that customer
  visit new_customer_session_path
  fill_in 'Email', with: customer.email
  fill_in 'Password', with: customer.password
  click_button 'Sign in'
end

def sign_in_that customer
  visit new_customer_session_path
  fill_in 'Email', with: customer.email
  fill_in 'Password', with: customer.password
  click_button 'Sign in'
end