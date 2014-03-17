require "spec_helper"
require "cancan/matchers"

describe "Customer" do
  describe "abilities" do
    let(:customer) {}
    subject(:ability){ Ability.new(customer) }

    context "when signed in as admin" do
      let(:customer){ FactoryGirl.create :customer, admin: true }
      it{ should be_able_to(:manage, :all) }
      it{ should be_able_to(:access, :rails_admin) }
      it{ should be_able_to(:state, Order.new) }
    end

    context "when signed in as simple customer" do
      let(:customer){ FactoryGirl.create :customer }
      it{ should be_able_to(:add_wish, Book.new) }
      it{ should be_able_to(:remove_wish, Book.new) }
      it{ should be_able_to(:wishers, Book.new) }
      it{ should be_able_to(:author_filter, Book.new) }
      it{ should be_able_to(:category_filter, Book.new) }
      it{ should be_able_to(:top_rated, Book.new) }
      it{ should be_able_to(:manage, OrderItem.new) }
      it{ should be_able_to(:read, Address.new) }
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:read, Order.new) }
      it{ should be_able_to(:read, Rating.new) }
      it{ should be_able_to(:read, Category.new) }
      it{ should be_able_to(:read, Author.new) }
      it{ should be_able_to(:manage, Address.new) }
      it{ should be_able_to(:manage, CreditCard.new) }
      it{ should be_able_to(:manage, Customer.new) }
      it{ should be_able_to(:new, Rating.new) }
      it{ should be_able_to(:create, Rating.new) }
      it{ should be_able_to(:new, Order.new) }
      it{ should be_able_to(:update_with_coupon, Order.new) }
      it{ should be_able_to(:remove_coupon, Order.new) }
      it{ should be_able_to(:confirm, Order.new) }
      it{ should be_able_to(:place, Order.new) }
      it{ should be_able_to(:delivery, Order.new) }
      it{ should be_able_to(:add_delivery, Order.new) }
      it{ should be_able_to(:edit_delivery, Order.new) }
      it{ should be_able_to(:destroy, Order.new) }  
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end

    context "when not signed in" do
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:read, Category.new) }
      it{ should be_able_to(:read, Author.new) }
      it{ should be_able_to(:wishers, Book.new) }
      it{ should be_able_to(:author_filter, Book.new) }
      it{ should be_able_to(:category_filter, Book.new) }
      it{ should be_able_to(:top_rated, Book.new) }
      it{ should be_able_to(:manage, OrderItem.new) }  
      it{ should be_able_to(:manage, ShipAddress.new) }
      it{ should be_able_to(:manage, BillAddress.new) }
      it{ should be_able_to(:manage, CreditCard.new) }
      it{ should be_able_to(:new, Order.new) }
      it{ should be_able_to(:update_with_coupon, Order.new) }
      it{ should be_able_to(:remove_coupon, Order.new) }
      it{ should be_able_to(:confirm, Order.new) }
      it{ should be_able_to(:delivery, Order.new) }
      it{ should be_able_to(:add_delivery, Order.new) }
      it{ should be_able_to(:edit_delivery, Order.new) }
      it{ should be_able_to(:destroy, Order.new) }  
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end        
  end
end