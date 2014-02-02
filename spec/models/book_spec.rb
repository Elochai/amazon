require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book) }
  let(:second_book) { FactoryGirl.create(:book) }
  let(:rating) { FactoryGirl.create(:rating, book_id: book.id) } #rating = 10
  let(:rating2) { FactoryGirl.create(:rating, rating: 6, book_id: book.id) }
  let(:rating_for_second_book) { FactoryGirl.create(:rating, rating: 6, book_id: second_book.id, approved: true) }
  context "associations" do
    it { expect(book).to have_many(:ratings).dependent(:destroy) }
    it { expect(book).to belong_to(:author) }
    it { expect(book).to belong_to(:category) }
  end
  context "validations" do
    it { expect(book).to validate_presence_of(:title) }
    it { expect(book).to validate_presence_of(:price) }
    it { expect(book).to validate_presence_of(:in_stock) }
    it { expect(book).to validate_numericality_of(:in_stock).is_greater_than_or_equal_to(0) }
    it { expect(book).to validate_numericality_of(:price).is_greater_than_or_equal_to(0.01) }
  end
  context "default scope" do
    it "orders by descending rating" do
      expect(Book.all).to eq [book, second_book]
    end
  end
  context ".add_in_stock!" do
    it "increases 'in_stock' attr quantity by 1" do
      expect{ book.add_in_stock! }.to change{ book.in_stock }.by(1) 
    end
  end
  context ".avg_rating" do
    it "shows avarage rating of the book if it has approved rating" do
      rating.approved = true
      rating2.approved = true
      rating.save!
      rating2.save!
      expect(book.avg_rating).to eq(8)
    end
    it "shows zero rating for the book if it hasn't approved rating" do
      rating.approved = false
      rating2.approved = false
      rating.save!
      rating2.save!
      expect(book.avg_rating).to eq(0)
    end
    it "shows zero rating for the book if it has no rating" do
      rating.destroy
      expect(book.avg_rating).to eq(0)
    end
  end
end

