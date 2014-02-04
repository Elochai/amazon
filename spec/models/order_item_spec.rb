require 'spec_helper'

describe OrderItem do
  let(:order_item) { FactoryGirl.create(:order_item, book: book) } 
  let(:order_item_quantity_2) { FactoryGirl.build(:order_item, quantity: 2, book: book) } #book price is 50.00 in factory 'book'
  let(:failed_order_item) { FactoryGirl.build(:order_item, book: book_that_not_in_stock) }
  let(:book) { FactoryGirl.create(:book) }
  let(:book_that_not_in_stock) { FactoryGirl.create(:book, in_stock: 0) }

  context "associations" do
    it { expect(order_item).to belong_to(:book) }
    it { expect(order_item).to belong_to(:order) }
    it { expect(order_item).to belong_to(:customer) }
  end
  context "validations" do
    it { expect(order_item).to validate_presence_of(:quantity) }
    it "fails to save 'order_item' if book not in stock" do
      expect { failed_order_item.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  context ".count_price" do
    it "called before save" do
      expect(order_item_quantity_2).to receive(:count_price!)
      order_item_quantity_2.save
    end
    it "counts total price properly" do
      expect{ order_item_quantity_2.count_price! }.to change{ order_item_quantity_2.price }.to(100.00)  #50 * 2
    end
  end
end