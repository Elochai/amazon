require 'spec_helper'

describe Coupon do
  let(:coupon) { FactoryGirl.create(:coupon) } 

  context "validations" do
    it { expect(coupon).to validate_presence_of(:number) }
    it { expect(coupon).to validate_presence_of(:discount) }
    it { expect(coupon).to validate_numericality_of(:discount).is_greater_than_or_equal_to(0.01) }
  end
end