require 'spec_helper'

feature "Registration" do
  before do 
    visit new_customer_registration_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678', match: :prefer_exact
    fill_in 'Password confirmation', with: '12345678', match: :prefer_exact
  end

  scenario 'Visitor registers successfully via register form' do
    click_button 'Sign up'
    expect(page).to_not have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Welcome! You have signed up successfully'
    expect(page).to have_content "Signed in as user@gmail.com"
  end

  scenario 'Visitor cant register if password not confirmed' do
    fill_in 'Password confirmation', with: '11111111', match: :prefer_exact
    click_button 'Sign up'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

    scenario 'Visitor cant register if password not filled in' do
    fill_in 'Password', with: '', match: :prefer_exact
    click_button 'Sign up'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content "Password can't be blank"
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

    scenario 'Visitor cant register if email no filled in' do
    fill_in 'Email', with: ''
    click_button 'Sign up'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Email is invalid"
  end

  scenario 'Visitor cant register if email is invalid (dont match regexp)' do
    fill_in 'Email', with: 'usergmail.com'
    click_button 'Sign up'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content "Email is invalid"
  end
end