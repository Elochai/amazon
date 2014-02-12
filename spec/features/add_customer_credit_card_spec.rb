require 'spec_helper'

feature "Add customer credit card" do
  given!(:country) {FactoryGirl.create(:country)}
  given!(:customer) {FactoryGirl.create(:customer)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit edit_customer_registration_path
  end

  scenario 'A customer adds credit card info to his profile' do
    click_on 'Add credit card'
    within '#cc' do 
      fill_in 'Card number', with: '123456789012345'
      fill_in 'CVV', with: '1234'
      fill_in 'Owner firstname', with: 'Bohdan'
      fill_in 'Owner lastname', with: 'Cherevatenko'
      fill_in 'Exp month', with: '1'
      fill_in 'Exp year', with: '2015'
    end
    click_on 'Create credit card'
    expect(page).to have_content '123456789012345'
    expect(page).to have_content 'Credit card was successfully created.'
    expect(page).to_not have_content 'Add credit card'
  end
end