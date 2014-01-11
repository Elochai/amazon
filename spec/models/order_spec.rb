require 'spec_helper'

describe Order do
  let(:unsaved_order) { FactoryGirl.build(:order) } 
  let(:order) { FactoryGirl.create(:order, id: 1) } 
  let(:order_with_items) { FactoryGirl.create :order_with_items }

  context "associations" do
    it { expect(order).to belong_to(:customer) }
    it { expect(order).to belong_to(:credit_card) }
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
  context ".total_price_count!" do
    it "called after find" do
      expect(order).to receive(:count_total_price!)
      Order.find(1)
      #todo fix it
    end
  end
  context ".set_in_progress!" do
    it "called after create" do
      expect(unsaved_order).to receive(:set_in_progress!)
      unsaved_order.save
    end
    it "changes state of created record to 'in progress'" do
      new_order = FactoryGirl.build(:order, state: "shipped")
      expect { new_order.save }.to change{ new_order.state }.to("in progress")  
    end
  end
  context ".set_shipped!" do
    it "changes state of created record to 'in progress'" do
      new_order = FactoryGirl.build(:order, state: "completed")
      expect { new_order.set_shipped! }.to change{ new_order.state }.to("shipped")  
    end
  end
  context ".set_completed!" do
    it "changes state of created record to 'in progress'" do
      new_order = FactoryGirl.build(:order, state: "shipped")
      expect { new_order.set_completed! }.to change{ new_order.state }.to("completed")  
    end
  end
  context ".complete!" do
    it "set today's day into 'completed_at' param" do
      expect { order.complete_order! }.to change{order.completed_at}.to(Date.today)  
    end
  end
end

