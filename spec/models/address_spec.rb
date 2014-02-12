require 'spec_helper'

describe Address do
  let(:address) { FactoryGirl.create(:address) }

  context "associations" do
    it { expect(address).to belong_to(:country) }
    it { expect(address).to belong_to(:order) }
    it { expect(address).to belong_to(:customer) }
  end
  context "validations" do
    it { expect(address).to validate_presence_of(:city) }
    it { expect(address).to validate_presence_of(:phone) }
    it { expect(address).to validate_presence_of(:zipcode) }
    it { expect(address).to validate_presence_of(:address) }
    it { expect(address).to allow_value('12345').for(:zipcode).with_message("should contain 5 digits")}
    it { expect(address).to_not allow_value('1234').for(:zipcode).with_message("should contain 5 digits")}
    it { expect(address).to_not allow_value('abcde').for(:zipcode).with_message("should contain 5 digits")}
  end
end
