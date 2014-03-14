require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create(:order) } 

  context "associations" do
    it { expect(order).to belong_to(:customer) }
    it { expect(order).to belong_to(:delivery) }
    it { expect(order).to have_one(:credit_card).dependent(:destroy) }
    it { expect(order).to have_one(:ship_address).class_name('ShipAddress').dependent(:destroy) }
    it { expect(order).to have_one(:bill_address).class_name('BillAddress').dependent(:destroy) }
    it { expect(order).to have_many(:order_items).dependent(:destroy) }
  end

  context "validations" do
    it { expect(order).to validate_presence_of(:state) }
    it { expect(order).to validate_presence_of(:price) }
    it { expect(order).to ensure_inclusion_of(:checkout_step).in_range(1..5) }
    it { expect(order).to ensure_inclusion_of(:state).in_array(%w(in_progress in_queue in_delivery delivered))}
  end

  context ".complete!" do
    it "set today's day into 'completed_at' attribute " do
      expect { order.complete! }.to change{order.completed_at}.to(Date.today)  
    end
  end

  context 'other methods' do
    before do
      @book = FactoryGirl.create :book, price: 20, in_stock: 4
      FactoryGirl.create :order_item, quantity: 2, book_id: @book.id, order_id: order.id
      @coupon = FactoryGirl.create :coupon, discount: 0.5
      @delivery = FactoryGirl.create :delivery, price: 10
    end

    context '.total_price' do
      it "shows current order total price (with discount, delivery, books)" do
        order.update(delivery_id: @delivery.id, coupon_id: @coupon.id)
        expect(order.total_price).to eq(30)
      end
    end

    context '.books_price' do
      it "shows current order books price (with discount)" do
        order.update(delivery_id: @delivery.id, coupon_id: @coupon.id)
        expect(order.books_price).to eq(20) # do not takes in mind delivery price
      end
    end

    context '.to_queue!' do
      before do
        @customer = FactoryGirl.create :customer
      end
      it "decreases order books 'in_stock' value by bought amount" do
        order.to_queue!(@customer)
        expect(@book.reload.in_stock).to eq(2) 
      end
      it "updates current order with current_customer" do
        expect{order.to_queue!(@customer)}.to change(order, :customer_id).to(@customer.id) 
      end
      it "updates current order with total_price" do
        expect{order.to_queue!(@customer)}.to change(order, :price).to(order.total_price) 
      end
      it "updates current order with 'in_queue' state" do
        expect{order.to_queue!(@customer)}.to change(order, :state).to('in_queue') 
      end
    end
  end

  context '.next_step!' do
    it "increases order 'checkout_step' attribute by 1" do
      expect{order.next_step!}.to change(order, :checkout_step).by(1)
    end
  end

  context 'self.delete_abandoned!' do
    it "destroyes orders, created 5 hours ago and with 'in_progress' state" do
      order.update(updated_at: 5.hours.ago)
      expect{Order.delete_abandoned!}.to change(Order, :count).by(-1)
    end
  end
end

