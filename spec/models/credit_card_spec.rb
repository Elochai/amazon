require 'spec_helper'

describe CreditCard do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  context "associations" do
    it { expect(credit_card).to belong_to(:order) }
    it { expect(credit_card).to belong_to(:customer) }
  end
  context "validations" do
    it { expect(credit_card).to validate_presence_of(:number) }
    it { expect(credit_card).to validate_uniqueness_of(:number) }
    it { expect(credit_card).to validate_presence_of(:cvv) }
    it { expect(credit_card).to validate_presence_of(:expiration_month) }
    it { expect(credit_card).to validate_presence_of(:expiration_year) }
    it { expect(credit_card).to validate_presence_of(:firstname) }
    it { expect(credit_card).to validate_presence_of(:lastname) }
    it { expect(credit_card).to allow_value('1234567890123456').for(:number).with_message("should contain 12-16 digits")}
    it { expect(credit_card).to_not allow_value('12345').for(:number).with_message("should contain 12-16 digits")}
    it { expect(credit_card).to allow_value('1234').for(:cvv).with_message("should 3-4 digits")}
    it { expect(credit_card).to_not allow_value('12345').for(:cvv).with_message("should 3-4 digits")}
  end
end
