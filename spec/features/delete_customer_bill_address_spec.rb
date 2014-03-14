require 'spec_helper'
require 'features_spec_helper'
feature "Delete customer bill address order" do
  given!(:country) {FactoryGirl.create(:country)}
  given!(:customer) {FactoryGirl.create(:customer)}

  before do
    sign_in_that customer
    visit edit_customer_registration_path
    click_on 'Add bill address'
    within '#ba' do
      select 'Ukraine', from: 'Country'
      fill_in 'City', with:'Dnipropetrovsk'
      fill_in 'Address', with:'Some address'
      fill_in 'Zip code', with:'12345'
      fill_in 'Phone', with:'0671111111'
    end
    click_on 'Create bill address'
  end

  scenario 'A customer deletes bill address info in his profile' do
    click_on 'Delete bill address'
    expect(page).to_not have_content "Some address"
    expect(page).to have_content "Bill address was successfully deleted."
    expect(page).to have_content "Add bill address"
  end
end