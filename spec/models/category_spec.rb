require 'spec_helper'

describe Category do
  let(:category) { FactoryGirl.create(:category) }

  context "associations" do
    it { expect(category).to have_many(:books) }
  end
  context "validations" do
    it { expect(category).to validate_presence_of(:title) }
    it { expect(category).to validate_uniqueness_of(:title) }
  end
  context ".number_of_books" do
    it "shows number of books in this category" do
      category_book = FactoryGirl.create(:book, category_id: category.id)
      expect(category.number_of_books).to eq(1)
    end
  end
end