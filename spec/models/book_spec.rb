require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book) }

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
end

