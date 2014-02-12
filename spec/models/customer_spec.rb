require 'spec_helper'

describe Customer do
  let(:customer) { FactoryGirl.create(:customer) }

  context "associations" do
    it { expect(customer).to have_many(:orders).dependent(:destroy) }
    it { expect(customer).to have_one(:credit_card).dependent(:destroy) }
    it { expect(customer).to have_many(:order_items).dependent(:destroy) }
    it { expect(customer).to have_many(:ratings).dependent(:destroy) }
    it { expect(customer).to have_one(:bill_address).class_name('BillAddress').dependent(:destroy) }
    it { expect(customer).to have_one(:ship_address).class_name('ShipAddress').dependent(:destroy) }
  end
  context "validations" do
    it { expect(customer).to validate_presence_of(:email) }
    it { expect(customer).to allow_value("example@gmail.com").for(:email) }
    it { expect(customer).not_to allow_value("example.com").for(:email) }
    it { expect(customer).to validate_uniqueness_of(:email) }
  end
  context ".order_price" do
    it "shows total price of all customer books in the cart" do
      book = FactoryGirl.create(:book, price: 10.00, in_stock: 1) 
      book_2 = FactoryGirl.create(:book, price: 20.00, in_stock: 2) 
      order_item = OrderItem.create(customer_id: customer.id, quantity: 1, price: 10.00, book_id: book.id, order_id: nil) 
      order_item_2 = OrderItem.create(customer_id: customer.id, quantity: 2, price: 20.00, book_id: book_2.id, order_id: nil) 
      expect(customer.order_price).to eq(50.00)
    end
  end
end

