require 'spec_helper'
require 'features_spec_helper'
feature "Delete current order" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:country) {FactoryGirl.create(:country)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}

  scenario "A customer can delete current order" do
    visit book_path(book)
    click_on 'Add to cart'
    click_on 'Delete order'
    expect(page).to have_content 'Order was successfully deleted.'
  end
end
