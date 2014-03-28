require "spec_helper"
require "cancan/matchers"

describe "Customer" do
  describe "abilities" do
    let(:customer) {}
    let(:current_order) {}
    subject(:ability){ Ability.new(customer, current_order) }

    context "when signed in as admin" do
      let(:customer){ FactoryGirl.create :customer, admin: true }
      let(:current_order){ FactoryGirl.create :order }
      it{ should be_able_to(:manage, :all) }
      it{ should be_able_to(:access, :rails_admin) }
      it{ should be_able_to(:state, Order.new) }
    end

    context "when signed in as simple customer" do
      let(:customer){ FactoryGirl.create :customer }
      let(:current_order){ FactoryGirl.create :order }
      it{ should be_able_to(:add_wish, Book.new) }
      it{ should be_able_to(:remove_wish, Book.new) }
      it{ should be_able_to(:wishers, Book.new) }
      it{ should be_able_to(:top_rated, Book.new) }
      it{ should be_able_to(:index, OrderItem.new) }
      it{ should be_able_to(:clear_cart, OrderItem.new) }
      it{ should be_able_to(:create, OrderItem.new) }
      it{ should be_able_to(:edit, OrderItem.new(:order_id => current_order.id)) }
      it{ should be_able_to(:update, OrderItem.new(:order_id => current_order.id)) }
      it{ should be_able_to(:destroy, OrderItem.new(:order_id => current_order.id)) }
      it{ should be_able_to(:read, Address.new(type: 'CustomerBillAddress', :customer_id => customer.id)) }
      it{ should be_able_to(:read, Address.new(type: 'CustomerShipAddress', :customer_id => customer.id)) }
      it{ should be_able_to(:read, Address.new(type: 'BillAddress', :order_id => current_order.id)) }
      it{ should be_able_to(:read, Address.new(type: 'ShipAddress', :order_id => current_order.id)) }
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:read, Order.new(:customer_id => customer.id)) }
      it{ should be_able_to(:read, Rating.new) }
      it{ should be_able_to(:read, Category.new) }
      it{ should be_able_to(:read, Author.new) }
      it{ should be_able_to(:new, CreditCard.new) }
      it{ should be_able_to(:create, CreditCard.new) }
      it{ should be_able_to(:update, CreditCard.new(:order_id => current_order.id)) }
      it{ should be_able_to(:edit, CreditCard.new(:order_id => current_order.id)) }
      it{ should be_able_to(:manage, Customer.new) }
      it{ should be_able_to(:new, Rating.new) }
      it{ should be_able_to(:create, Rating.new) }
      it{ should be_able_to(:new, Order.new) }
      it{ should be_able_to(:update_with_coupon, Order.new) }
      it{ should be_able_to(:remove_coupon, Order.new) }
      it{ should be_able_to(:confirm, Order.new) }
      it{ should be_able_to(:checkout, Order.new) }
      it{ should be_able_to(:next_step, Order.new) } 
      it{ should be_able_to(:place, Order.new) }
      it{ should be_able_to(:delivery, Order.new) }
      it{ should be_able_to(:add_delivery, Order.new) }
      it{ should be_able_to(:edit_delivery, Order.new) } 
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
      it{ should_not be_able_to(:edit, OrderItem.new) }
      it{ should_not be_able_to(:update, OrderItem.new) }
      it{ should_not be_able_to(:destroy, OrderItem.new) }
      it{ should_not be_able_to(:read, Address.new(type: 'CustomerBillAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'CustomerShipAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'BillAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'ShipAddress')) }
      it{ should_not be_able_to(:update, CreditCard.new) }
      it{ should_not be_able_to(:edit, CreditCard.new) }
      it{ should_not be_able_to(:read, Order.new) }
    end

    context "when not signed in" do
      let(:current_order){ FactoryGirl.create :order }
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:read, Category.new) }
      it{ should be_able_to(:read, Author.new) }
      it{ should be_able_to(:wishers, Book.new) }
      it{ should be_able_to(:top_rated, Book.new) }
      it{ should be_able_to(:index, OrderItem.new) }
      it{ should be_able_to(:clear_cart, OrderItem.new) }
      it{ should be_able_to(:create, OrderItem.new) }
      it{ should be_able_to(:edit, OrderItem.new(:order_id => current_order.id)) }
      it{ should be_able_to(:update, OrderItem.new(:order_id => current_order.id)) }
      it{ should be_able_to(:destroy, OrderItem.new(:order_id => current_order.id)) }  
      it{ should be_able_to(:read, Address.new(type: 'BillAddress', :order_id => current_order.id)) }
      it{ should be_able_to(:read, Address.new(type: 'ShipAddress', :order_id => current_order.id)) }
      it{ should be_able_to(:new, CreditCard.new) }
      it{ should be_able_to(:create, CreditCard.new) }
      it{ should be_able_to(:update, CreditCard.new(:order_id => current_order.id)) }
      it{ should be_able_to(:edit, CreditCard.new(:order_id => current_order.id)) }
      it{ should be_able_to(:new, Order.new) }
      it{ should be_able_to(:update_with_coupon, Order.new) }
      it{ should be_able_to(:remove_coupon, Order.new) }
      it{ should be_able_to(:confirm, Order.new) }
      it{ should be_able_to(:delivery, Order.new) }
      it{ should be_able_to(:add_delivery, Order.new) }
      it{ should be_able_to(:edit_delivery, Order.new) }
      it{ should be_able_to(:checkout, Order.new) }
      it{ should be_able_to(:next_step, Order.new) } 
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
      it{ should_not be_able_to(:edit, OrderItem.new) }
      it{ should_not be_able_to(:update, OrderItem.new) }
      it{ should_not be_able_to(:destroy, OrderItem.new) }
      it{ should_not be_able_to(:read, Address.new(type: 'CustomerBillAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'CustomerShipAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'BillAddress')) }
      it{ should_not be_able_to(:read, Address.new(type: 'ShipAddress')) }
      it{ should_not be_able_to(:update, CreditCard.new) }
      it{ should_not be_able_to(:edit, CreditCard.new) }
      it{ should_not be_able_to(:read, Order.new) }
    end        
  end
end