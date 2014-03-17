require 'spec_helper'
require 'features_spec_helper'
feature "Session" do
  before(:each) do
    customer = FactoryGirl.create(:customer)
  end
  scenario 'A customer creates new session successfully with valid data' do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    expect(page).to_not have_content 'Sign in'
    expect(page).to_not have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content "Profile (user@gmail.com)"
  end

  scenario "A customer can not create new session if he enter incorrect password" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '11111111'
    click_button 'Sign in'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "A customer can not create new session if he enter incorrect email" do
    visit new_customer_session_path
    fill_in 'Email', with: 'not_user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "A customer destroyes session successfully if he click 'Sign out' button" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    click_link 'Sign out'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Signed out successfully'
    expect(page).to_not have_content "Profile (user@gmail.com)"
  end
end