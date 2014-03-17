require 'spec_helper'
require 'features_spec_helper'
feature "Add customer ship address order" do
  given!(:country) {FactoryGirl.create(:country)}
  given!(:customer) {FactoryGirl.create(:customer)}

  before do
    sign_in_that customer
    visit edit_customer_registration_path
  end

  scenario 'A customer adds ship address info to his profile' do
    click_on 'Add ship address'
    within '#sa' do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    click_on 'Create ship address'
    expect(page).to have_content "Some address"
    expect(page).to have_content "Ship address was successfully created."
    expect(page).to_not have_content "Add ship address"
  end
end