require 'spec_helper'

feature "Show all authors" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:author2) {FactoryGirl.create(:author, firstname: 'Lev', lastname: 'Tolstoy')}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 0, author: author)}
  before(:each) do
    visit '/authors'
  end
  scenario "Shows all author full names in index view" do
    expect(page).to have_content author.full_name
    expect(page).to have_content author2.full_name
  end
  scenario "Shows number of books for each author in index view" do
    expect(page).to have_content author.number_of_books
    expect(page).to have_content author2.number_of_books
  end
end