require 'spec_helper'

feature "Session" do
  before(:each) do
    customer = FactoryGirl.create(:customer)
  end
  scenario 'New session creates if customer successfully signs in' do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    expect(page).to_not have_content 'Sign in'
    expect(page).to_not have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content "Signed in as user@gmail.com"
  end

  scenario "New session won't create if customer fills incorrect password" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '11111111'
    click_button 'Sign in'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "New session wont't create if customer fills incorrect email" do
    visit new_customer_session_path
    fill_in 'Email', with: 'not_user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "New session will be destroyed if customer click 'Sign out' button" do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    click_link 'Sign out'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Signed out successfully'
    expect(page).to_not have_content "Signed in as user@gmail.com"
  end
end