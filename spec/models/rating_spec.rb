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
  context ".calculate_book_avg_rating" do
    it "calls after save" do
      expect(rating).to receive(:calculate_book_avg_rating)
      rating.save!
    end
    it "calls recalculate_avg_rating! method for rating's book" do
      expect(rating.book).to receive(:recalculate_avg_rating!)
      rating.calculate_book_avg_rating
    end
  end
end
