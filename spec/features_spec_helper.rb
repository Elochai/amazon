def fill_addresses
  click_on 'Checkout'
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
end

def choose_delivery
  delivery = FactoryGirl.create :delivery, name: "Delivery", price: 15
  fill_addresses
  choose("delivery_id_" + "#{delivery.id}")
  click_on 'Save and continue'
end

def fill_credit_card
  choose_delivery
  fill_in 'Card number', with: '12345678901234'
  fill_in 'CVV', with: '1234'
  fill_in 'Owner firstname', with: 'Firstname'
  fill_in 'Owner lastname', with: 'Lastname'
  if Time.now.month == 12
    select "1", from: 'Exp month'
  else
    select "#{Time.now.month+1}", from: 'Exp month'
  end
  select "#{Time.now.year}", from: 'Exp year'
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