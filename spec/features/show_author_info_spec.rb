require 'spec_helper'

feature "Show author info" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author)}
  given!(:book2) {FactoryGirl.create(:book, title: "LOTR II", price: 20.00, in_stock: 0, author: author)}
  before(:each) do
    visit author_path(author)
  end

  scenario "Shows author full name in show view" do
    expect(page).to have_content author.full_name
  end
  scenario "Shows author biography in show view" do
    expect(page).to have_content author.biography
  end
  scenario "Shows author number of books in show view" do
    expect(page).to have_content author.number_of_books
  end
  scenario "Shows author books in show view" do
    expect(page).to have_content book.title
    expect(page).to have_content book2.title
  end
end