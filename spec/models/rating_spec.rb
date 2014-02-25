require 'spec_helper'

describe Rating do
  let(:book) { FactoryGirl.create :book }
  let(:rating) { FactoryGirl.create(:rating, approved: false, book: book, rating: 5) }
  let(:rating2) { FactoryGirl.create(:rating, approved: false, book: book, rating: 3) }

  context "associations" do
    it { expect(rating).to belong_to(:customer) }
    it { expect(rating).to belong_to(:book) }
  end
  context "validations" do
    it { expect(rating).to ensure_inclusion_of(:rating).in_range(1..10) }
    it { expect(rating).to validate_presence_of(:rating) }
  end
  context ".avg_rating" do
    it "calls after save" do
      expect(rating).to receive(:avg_rating)
      rating.save!
    end
    it "counts and set avarage rating of the book if it has approved ratings" do
      rating.approved = true
      rating2.approved = true
      rating.save!
      rating2.save!
      expect(book.reload.avg_rating).to eq(4)
    end
    it "sets zero rating for the book if it hasn't approved rating" do
      rating.approved = false
      rating2.approved = false
      rating.save!
      rating2.save!
      expect(book.avg_rating).to eq(0)
    end
    it "sets zero rating for the book if it has no rating" do
      Rating.all.destroy_all
      expect(book.avg_rating).to eq(0)
    end
  end
end
