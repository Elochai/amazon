require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:order_item) { FactoryGirl.create(:order_item, customer_id: customer.id, quantity: 1, book_id: book.id, order_id: nil) }
  let(:order_item_2) { FactoryGirl.create(:order_item, customer_id: customer.id, quantity: 2, book_id: book_2.id, order_id: nil) }
  let(:book) { FactoryGirl.create(:book, price: 10.00, in_stock: 1) }
  let(:book_2) { FactoryGirl.create(:book, price: 20.00, in_stock: 2) }

  context "associations" do
    it { expect(customer).to have_many(:orders).dependent(:destroy) }
    it { expect(customer).to have_many(:credit_cards).dependent(:destroy) }
     it { expect(customer).to have_many(:order_items).dependent(:destroy) }
      it { expect(customer).to have_many(:ratings).dependent(:destroy) }
  end
  context "validations" do
    it { expect(customer).to validate_presence_of(:email) }
    it { expect(customer).to allow_value("example@gmail.com").for(:email) }
    it { expect(customer).not_to allow_value("example.com").for(:email) }
    it { expect(customer).to validate_uniqueness_of(:email) }
    it { expect(customer).to validate_presence_of(:password) }
  end
  context ".order_price" do
    it "shows total price of all customer books in the cart" do
      expect(customer.order_price). to eq(50.00)
    end
  end
end

