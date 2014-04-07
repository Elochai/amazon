require 'spec_helper'

describe OrderItemsController do
  before(:each) do
    create_ability!
    create_order!
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book, in_stock: 4
    @order_item = FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, order_id: @order.id
    sign_in @customer
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
      it "redirects to root_path" do
        get :edit, id: @order_item.id
        expect(response).to redirect_to root_path
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
        it "redirects to order_items_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
          expect(response).to redirect_to order_items_path
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
        it "do not redirects to order_items_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item)
          expect(response).to_not redirect_to order_items_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @order_item's attributes" do
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          @order_item.reload
          expect(@order_item.quantity).to_not eq "quantity"
        end
        it "redirects to root_path" do  
          put :update, id: @order_item.id, order_item: FactoryGirl.attributes_for(:order_item, quantity: "quantity")
          expect(response).to redirect_to root_path
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
      end
      it "redirects to order_items_path" do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to order_items_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, OrderItem
        OrderItem.stub(:find).and_return @order_item
      end
      it "do not deletes order_item" do
        expect{delete :destroy, id: @order_item.id}.to_not change(OrderItem, :count)
      end
      it "redirects to root_path" do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET clear_cart' do
    context "with clear_cart ability" do
      before do
        @ability.can :clear_cart, OrderItem
      end
      it "deletes all order_items in cart" do
        FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, order_id: @order.id
        expect{get :clear_cart}.to change(OrderItem, :count).by(-2)
        get :clear_cart
      end
      it "redirects to order_items_path" do
        get :clear_cart
        expect(response).to redirect_to order_items_path
      end
    end
    context "without clear_cart ability" do
      before do
        @ability.cannot :clear_cart, OrderItem
      end
      it "do not deletes all order_items in cart" do
        FactoryGirl.create :order_item, quantity: 1, book_id: @book.id, order_id: @order.id
        expect{get :clear_cart}.to_not change(OrderItem, :count).by(-2)
        get :clear_cart
      end
      it "redirects to root_path" do
        get :clear_cart
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "with create ability" do
      before do
        @ability.can :create, OrderItem
      end
      context "with valid attributes" do
        it "creates new order_item if it is not in the cart already" do
          OrderItem.destroy_all
          expect {post :create, book_id: @book.id, quantity: 1}.to change(OrderItem, :count).by(1)
        end
        it "updates order_item quantity by certain amount if it is in the cart already" do
          post :create, book_id: @book.id, quantity: 1
          @order_item.reload
          expect(@order_item.quantity).to eq(2)
        end
        it "redirects to order_items_path" do
          post :create, book_id: @book.id
          expect(response).to redirect_to order_items_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new order_item if it is not in the cart already" do
          OrderItem.destroy_all
          expect {post :create, book_id: @book.id, quantity: -1}.to_not change(OrderItem, :count)
        end
        it "do not updates order_item quantity by 1 if it is in the cart already" do
          post :create, book_id: @book.id, quantity: -1
          @order_item.reload
          expect(@order_item.quantity).to eq(1)
        end
        it "redirects to root_path" do
          post :create, book_id: @book.id, quantity: -1
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without create ability" do
      before do
        @ability.cannot :create, OrderItem
      end
      context "with valid attributes" do
        it "do not creates new order_item if it is not in the cart already" do
          OrderItem.destroy_all
          expect {post :create, book_id: @book.id, quantity: 1}.to_not change(OrderItem, :count)
        end
        it "do not updates order_item quantity by 1 if it is in the cart already" do
          post :create, book_id: @book.id, quantity: 1
          @order_item.reload
          expect(@order_item.quantity).to eq(1)
        end
        it "redirects to root_path" do
          post :create, book_id: @book.id
          expect(response).to redirect_to root_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new order_item if it is not in the cart already" do
          OrderItem.destroy_all
          expect {post :create, book_id: @book.id, quantity: -1}.to_not change(OrderItem, :count)
        end
        it "do not updates order_item quantity by 1 if it is in the cart already" do
          post :create, book_id: @book.id, quantity: -1
          @order_item.reload
          expect(@order_item.quantity).to eq(1)
        end
        it "redirects to root_path" do
          post :create, book_id: @book.id, quantity: -1
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end

