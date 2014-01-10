require 'spec_helper'

describe Address do
  let(:address) { FactoryGirl.create(:address) }

  context "associations" do
    it { expect(address).to belong_to(:country) }
  end
  context "validations" do
    it { expect(address).to validate_presence_of(:city) }
    it { expect(address).to validate_presence_of(:phone) }
    it { expect(address).to validate_presence_of(:zipcode) }
    it { expect(address).to validate_presence_of(:address) }
  end
end
