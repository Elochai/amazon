require 'spec_helper'

describe CreditCard do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  context "associations" do
    it { expect(credit_card).to have_many(:orders).dependent(:destroy) }
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
  end
end
