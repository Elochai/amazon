require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create(:customer) }

  context "associations" do
    it { expect(customer).to have_many(:orders).dependent(:destroy) }
    it { expect(customer).to have_one(:credit_card).dependent(:destroy) }
    it { expect(customer).to have_many(:order_items).dependent(:destroy) }
    it { expect(customer).to have_many(:ratings).dependent(:destroy) }
    it { expect(customer).to have_one(:customer_bill_address).class_name('CustomerBillAddress').dependent(:destroy) }
    it { expect(customer).to have_one(:customer_ship_address).class_name('CustomerShipAddress').dependent(:destroy) }
    it { expect(customer).to have_and_belong_to_many(:wishes).class_name("Book") }
  end
  
  context "validations" do
    it { expect(customer).to validate_presence_of(:email) }
    it { expect(customer).to allow_value("example@gmail.com").for(:email) }
    it { expect(customer).not_to allow_value("example.com").for(:email) }
    it { expect(customer).to validate_uniqueness_of(:email) }
  end

  context ".did_not_rate?" do
    it "returns 'true' if customer did not rated current book" do
      book = FactoryGirl.create(:book)
      expect(customer.did_not_rate?(book.id)).to eq(true)
    end
    it "returns 'false' if customer has already rated current book" do
      book = FactoryGirl.create(:book)
      rating = FactoryGirl.create(:rating, customer: customer, book: book)
      expect(customer.did_not_rate?(book.id)).to eq(false)
    end
  end
end

