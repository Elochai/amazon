require 'spec_helper'

describe Order do
  let(:unsaved_order) { FactoryGirl.build(:order) } 
  let(:order) { FactoryGirl.create(:order) } 
  let(:order_with_items) { FactoryGirl.create :order_with_items }

  context "associations" do
    it { expect(order).to belong_to(:customer) }
    it { expect(order).to belong_to(:ship_address).class_name('Address') }
    it { expect(order).to belong_to(:bill_address).class_name('Address') }
    it { expect(order).to have_many(:order_items).dependent(:destroy) }
  end
  context "validations" do
    it { expect(order).to validate_presence_of(:total_price) }
    it { expect(order).to validate_presence_of(:state) }
    it { expect(order).to allow_value("in progress","shipped", "completed").for(:state) }
    it { expect(order).not_to allow_value("on plane").for(:state) }
  end
  context ".total_price" do
    it "called after find" do
      expect(order).to receive(:total_price)
      order.save
    end
    it "counts total price properly" do
      expect { order.save }.to change{order.total_price}.to(100.00)  
    end
  end
  context ".set_initial_state" do
    it "called after create" do
      expect(unsaved_order).to receive(:set_initial_state)
      unsaved_order.save
    end
    it "changes state of created record to 'in progress'" do
      expect { unsaved_order.save! }.to change{unsaved_order.state}.to("in progress")  
    end
  end
  context ".complete_order" do
    it "set today's day into 'completed_at' param" do
      expect { order.complete_order }.to change{order.completed_at}.to(Date.today)  
    end
  end
end

