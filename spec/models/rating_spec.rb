require 'spec_helper'

describe Rating do
  let(:rating) { FactoryGirl.create(:rating, approved: false) }

  context "associations" do
    it { expect(rating).to belong_to(:customer) }
    it { expect(rating).to belong_to(:book) }
  end
  context "validations" do
    it { expect(rating).to ensure_inclusion_of(:rating).in_range(1..10) }
    it { expect(rating).to validate_presence_of(:rating) }
  end
end
