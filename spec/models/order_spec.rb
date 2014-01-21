require 'spec_helper'

describe Order do
  let(:unsaved_order) { FactoryGirl.build(:order) } 
  let(:order) { FactoryGirl.create(:order) } 
  let(:order_with_items) { FactoryGirl.create :order_with_items }

  context "associations" do
    it { expect(order).to belong_to(:customer) }
    it { expect(order).to belong_to(:credit_card) }
    it { expect(order).to belong_to(:ship_address).class_name('Address') }
    it { expect(order).to belong_to(:bill_address).class_name('Address') }
    it { expect(order).to have_many(:order_items).dependent(:destroy) }
  end
  context "validations" do
    it { expect(order).to validate_presence_of(:price) }
    it { expect(order).to validate_presence_of(:state) }
    it { expect(order).to ensure_inclusion_of(:state).in_array(%w(in_progress shipped completed))}
  end
  context ".count_total_price!" do
    it "called before save" do
      expect(order).to receive(:count_total_price)
      order.save
    end
    it "counts total price properly" do
      expect { order_with_items.save }.to change{ order_with_items.price }.to(20.00)  
    end
  end
  context ".in_progress!" do
    it "changes state of created record to 'in_progress'" do
      new_order = FactoryGirl.build(:order, state: "shipped")
      expect { new_order.in_progress! }.to change{ new_order.state }.to("in_progress")  
    end
  end
  context ".shipped!" do
    it "changes state of created record to 'shipped'" do
      new_order = FactoryGirl.build(:order, state: "completed")
      expect { new_order.shipped! }.to change{ new_order.state }.to("shipped")  
    end
  end
  context ".complete!" do
    it "set today's day into 'completed_at' param" do
      expect { order.complete! }.to change{order.completed_at}.to(Date.today)  
    end
    it "changes state of created record to 'completed'" do
      new_order = FactoryGirl.build(:order, state: "in_progress")
      expect { new_order.complete! }.to change{ new_order.state }.to("completed")  
    end
  end
end

