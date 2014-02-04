require 'spec_helper'

feature "Show book info" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:customer2) {FactoryGirl.create(:customer, email: "user2@gmail.com")}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:rating) {FactoryGirl.create(:rating, book: book, approved: true, customer: customer, text: 'Awesome!')}
  given!(:rating2) {FactoryGirl.create(:rating, book: book, approved: false, customer: customer2, text: 'Bad!', rating: 2)}
  before(:each) do
    visit book_path(book)
  end

  scenario "Shows book title in show view" do
    expect(page).to have_content book.title
  end
  scenario "Shows book author in show view" do
    expect(page).to have_content book.author.full_name
  end
  scenario "Shows book price in show view" do
    expect(page).to have_content book.price
  end
  scenario "Shows book in_stock value in show view" do
    expect(page).to have_content book.in_stock
  end
  scenario "Shows book category in show view" do
    expect(page).to have_content book.category.title
  end
  scenario "Shows book description in show view" do
    expect(page).to have_content book.description
  end
  scenario "Shows book avarage rating in show view" do
    expect(page).to have_content book.avg_rating
  end
  scenario "Shows approved book rewiews, their authors and ratings in show view" do
    expect(page).to have_content rating.text
    expect(page).to have_content rating.rating
    expect(page).to have_content rating.customer.email
  end
  scenario "Don't show unapproved book rewiews and ratings in show view" do
    expect(page).to_not have_content rating2.text
    expect(page).to_not have_content rating2.rating.to_s + ' point(s)'
    expect(page).to have_content rating2.customer.email
  end
  scenario "Shows that review should be approved first message for unapproved reviews in show view" do
    expect(page).to have_content 'Review by user2@gmail.com should be approved first'
  end
end