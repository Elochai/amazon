require 'spec_helper'

describe Delivery do
  let(:delivery) { FactoryGirl.create(:delivery) } 

  context "associations" do
    it { expect(delivery).to have_many(:orders) }
  end
  context "validations" do
    it { expect(delivery).to validate_presence_of(:name) }
    it { expect(delivery).to validate_presence_of(:price) }
    it { expect(delivery).to validate_numericality_of(:price).is_greater_than_or_equal_to(0.01) }
  end
end
