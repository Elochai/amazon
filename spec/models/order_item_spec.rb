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
  context ".in_cart_with scope" do
    it "selects recors with certain book_id and without order_id" do
      expect(OrderItem.in_cart_with(book.id)).to include(order_item)
    end
    it "do not selects recors without certain book_id and with order_id" do
      new_book = FactoryGirl.create(:book)
      order = FactoryGirl.create(:order)
      new_order_item = FactoryGirl.create(:order_item, order: order, book: new_book)
      expect(OrderItem.in_cart_with(book.id)).to_not include(new_order_item)
    end
  end
   context ".in_cart scope" do
    it "selects recors without order_id" do
      expect(OrderItem.in_cart).to include(order_item)
    end
    it "do not selects recors with order_id" do
      new_book = FactoryGirl.create(:book)
      order = FactoryGirl.create(:order)
      new_order_item = FactoryGirl.create(:order_item, order: order, book: new_book)
      expect(OrderItem.in_cart).to_not include(new_order_item)
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