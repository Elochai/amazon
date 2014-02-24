require 'spec_helper'

feature "Add rating" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, author: author, category: category)}
  before(:each) do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
    visit book_path(book)
  end

  scenario "A customer can leave unapproved rating and review" do
    fill_in 'Your rating', with: '10'
    fill_in 'Your review', with: 'Awesome book!'
    click_on 'Rate and review'
    expect(page).to_not have_content customer.email.to_s + ' wrote:'
    expect(page).to_not have_content 'Awesome book!' 
    expect(page).to_not have_content '10'
  end
end