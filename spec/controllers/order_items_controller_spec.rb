require 'spec_helper'

describe OrderItemsController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book, in_stock: 4
    @order_item = FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, customer_id: @customer.id
    sign_in @customer
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @ability.can :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "receives find and return order_item" do
        expect(OrderItem).to receive(:find).with(@order_item.id.to_s).and_return @order_item
        get :edit, id: @order_item.id
      end
      it "assigns order_item" do
        get :edit, id: @order_item.id
        expect(assigns(:order_item)).to eq @order_item
      end
      it "renders template edit" do
        get :edit, id: @order_item.id
        expect(response).to render_template("edit")
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "redirects to customer_session_path" do
        get :edit, id: @order_item.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "receives find and return order_item" do
        expect(OrderItem).to receive(:find).with(@order_item.id.to_s).and_return @order_item
        put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
      end
      context "with valid attributes" do
        it "updates @order_item's attributes" do
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: 2)
          @order_item.reload
          expect(@order_item.quantity).to eq 2
        end
        it "redirects to new_order_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
          expect(response).to redirect_to new_order_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @order_item's attributes" do
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          @order_item.reload
          expect(@order_item.quantity).to_not eq "quantity"
        end
        it "renders template edit" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      context "with valid attributes" do
        it "do not updates @order_item's attributes" do
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: 2)
          @order_item.reload
          expect(@order_item.quantity).to_not eq 2
        end
        it "do not redirects to edit_customer_registration_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @order_item's attributes" do
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          @order_item.reload
          expect(@order_item.quantity).to_not eq "quantity"
        end
        it "redirects to customer_session_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context "with manage ability" do
      before do
        @ability.can :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "receives find and return order_item" do
        expect(OrderItem).to receive(:find).with(@order_item.id.to_s).and_return @order_item
        delete :destroy, id: @order_item.id
      end
      it "deletes order_item" do
        expect{delete :destroy, id: @order_item.id}.to change(OrderItem, :count).by(-1)
        delete :destroy, id: @order_item.id
      end
      it "redirects to new_order_path" do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to new_order_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "do not deletes order_item" do
        expect{delete :destroy, id: @order_item.id}.to_not change(OrderItem, :count)
        delete :destroy, id: @order_item.id
      end
      it "redirects to customer_session_path" do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe 'GET clear_cart' do
    context "with clear_cart ability" do
      before do
        @ability.can :clear_cart, OrderItem
      end
      it "deletes all order_items in cart" do
        FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, customer_id: @customer.id
        expect{get :clear_cart}.to change(OrderItem, :count).by(-2)
        get :clear_cart
      end
      it "redirects to new_order_path" do
        get :clear_cart
        expect(response).to redirect_to new_order_path
      end
    end
    context "without clear_cart ability" do
      before do
        @ability.cannot :clear_cart, OrderItem
      end
      it "do not deletes all order_items in cart" do
        FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, customer_id: @customer.id
        expect{get :clear_cart}.to_not change(OrderItem, :count).by(-2)
        get :clear_cart
      end
      it "redirects to customer_session_path" do
        get :clear_cart
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #add_to_order" do
    context "with add_to_order ability" do
      before do
        @ability.can :add_to_order, OrderItem
      end
      it "creates new order_item if it is not in the cart already" do
        OrderItem.destroy_all
        expect {post :add_to_order, book_id: @book.id, quantity: 1}.to change(OrderItem, :count).by(1)
      end
      it "updates order_item quantity by 1 if it is in the cart already" do
        post :add_to_order, book_id: @book.id, quantity: 1
        @order_item.reload
        expect(@order_item.quantity).to eq(2)
      end
      it "redirects to new_order_path" do
        post :add_to_order, book_id: @book.id
        expect(response).to redirect_to new_order_path
      end
    end
    context "without add_to_order ability" do
      before do
        @ability.cannot :add_to_order, OrderItem
      end
      it "do not creates new order_item if it is not in the cart already" do
        expect {post :add_to_order, book_id: @book.id, quantity: 1}.to_not change(OrderItem, :count)
      end
      it "do not updates order_item quantity by 1 if it is in the cart already" do
        @oi = FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id, quantity: 1
        post :add_to_order, book_id: @book.id, quantity: 1
        @oi.reload
        expect(@oi.quantity).to_not eq(2)
      end
      it "redirects to customer_session_path" do
        post :add_to_order, book_id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end

