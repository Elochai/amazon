require 'spec_helper'

feature "Delete customer ship address order" do
  given!(:country) {FactoryGirl.create(:country)}
  given!(:customer) {FactoryGirl.create(:customer)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit edit_customer_registration_path
    click_on 'Add ship address'
    within '#sa' do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    click_on 'Create ship address'
  end

  scenario 'A customer deletes ship address info in his profile' do
    click_on 'Delete ship address'
    expect(page).to_not have_content "Some address"
    expect(page).to have_content "Ship address was successfully deleted."
    expect(page).to have_content "Add ship address"
  end
end