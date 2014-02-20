require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create(:order) } 

  context "associations" do
    it { expect(order).to belong_to(:customer) }
    it { expect(order).to have_one(:credit_card).dependent(:destroy) }
    it { expect(order).to have_one(:ship_address).class_name('ShipAddress').dependent(:destroy) }
    it { expect(order).to have_one(:bill_address).class_name('BillAddress').dependent(:destroy) }
    it { expect(order).to have_many(:order_items).dependent(:destroy) }
    it { expect(order).to accept_nested_attributes_for(:credit_card).allow_destroy(true) }
    it { expect(order).to accept_nested_attributes_for(:ship_address).allow_destroy(true) }
    it { expect(order).to accept_nested_attributes_for(:bill_address).allow_destroy(true) }
  end
  context "validations" do
    it { expect(order).to validate_presence_of(:state) }
    it { expect(order).to validate_presence_of(:price) }
    it { expect(order).to ensure_inclusion_of(:state).in_array(%w(in_progress shipped completed))}
  end
  context ".complete!" do
    it "set today's day into 'completed_at' param " do
      expect { order.complete! }.to change{order.completed_at}.to(Date.today)  
    end
  end
  context ".decrease_in_stock!" do
    it "decreases 'in_stock' attr by amount of purchased books" do
      book = FactoryGirl.create(:book, title: "1", in_stock: 4, price: 10.00)
      order_with_items = FactoryGirl.create(:order, state: 'in_progress', price: 20.00)
      item1 = FactoryGirl.create(:order_item, book_id: book.id, quantity:1, order_id: order_with_items.id) 
      item2 = FactoryGirl.create(:order_item, book_id: book.id, quantity:1, order_id: order_with_items.id) 
      expect { order_with_items.decrease_in_stock! }.to change{ book.reload.in_stock }.to(2) 
    end
  end
end

