require 'spec_helper'

describe OrderItemsController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book, in_stock: 2
    @order_item = FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, customer_id: @customer.id
    sign_in @customer
  end

  describe "GET #edit" do
    before(:each) do
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

  describe "PUT #update" do
    before(:each) do
      OrderItem.stub(:find).and_return @order_item
    end
    it "receives find and return order_item" do
      expect(OrderItem).to receive(:find).with(@order_item.id.to_s).and_return @order_item
      put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
    end
    context "with valid attributes" do
      it "updates @order_item's attributes" do
        put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: 100)
        @order_item.reload
        expect(@order_item.quantity).to eq 100
      end
      it "redirects to new_order_path" do  
        put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
        expect(response).to redirect_to new_order_path
      end
    end
    context "with invalid attributes" do
      it "do not updates @order_item's attributes" do
        put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "one")
        @order_item.reload
        expect(@order_item.quantity).to_not eq "one"
      end
      it "renders template edit" do  
        put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: 0)
        expect(response).to render_template "edit"
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
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

  describe 'GET clear_cart' do
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
end

