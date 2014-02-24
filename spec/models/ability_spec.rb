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
      it{ should be_able_to(:clear_cart, OrderItem.new) }
    end

    context "when signed in as simple customer" do
      let(:customer){ FactoryGirl.create :customer }
      it{ should be_able_to(:add_wish, Book.new) }
      it{ should be_able_to(:remove_wish, Book.new) }
      it{ should be_able_to(:wishers, Book.new) }
      it{ should be_able_to(:author_filter, Book.new) }
      it{ should be_able_to(:category_filter, Book.new) }
      it{ should be_able_to(:add_to_order, Book.new) }
      it{ should be_able_to(:read, :all) }
      it{ should be_able_to(:manage, Address.new) }
      it{ should be_able_to(:manage, CreditCard.new) }
      it{ should be_able_to(:manage, Customer.new) }
      it{ should be_able_to(:new, Rating.new) }
      it{ should be_able_to(:create, Rating.new) }
      it{ should be_able_to(:new, Order.new) }
      it{ should be_able_to(:create, Order.new) }
      it{ should be_able_to(:clear_cart, OrderItem.new) }   
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
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end        
  end
end