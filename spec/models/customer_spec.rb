require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create(:customer) }

  context "associations" do
    it { expect(customer).to have_many(:orders).dependent(:destroy) }
    it { expect(customer).to have_many(:credit_cards).dependent(:destroy) }
  end
  context "validations" do
    it { expect(customer).to validate_presence_of(:email) }
    it { expect(customer).to allow_value("example@gmail.com").for(:email) }
    it { expect(customer).not_to allow_value("example.com").for(:email) }
    it { expect(customer).to validate_uniqueness_of(:email) }
    it { expect(customer).to validate_presence_of(:password) }
    it { expect(customer).to validate_presence_of(:firstname) }
    it { expect(customer).to validate_presence_of(:lastname) }
  end
end

