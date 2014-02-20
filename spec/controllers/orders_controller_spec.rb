require 'spec_helper'

describe OrdersController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @order = FactoryGirl.create :order, customer_id: @customer.id
    sign_in @customer
  end

  describe "GET #index" do
    it "returns an array of orders" do
      get :index 
      expect(assigns(:orders)).to eq [@order]
    end 
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "builds order" do
      get :new
      expect(assigns(:order)).to be_a_new Order
    end
    it "builds credit_card" do
      get :new
      expect(assigns(:credit_card)).to be_a_new CreditCard
    end
    it "builds bill_address" do
      get :new
      expect(assigns(:bill_address)).to be_a_new BillAddress
    end
    it "builds ship_address" do
      get :new
      expect(assigns(:ship_address)).to be_a_new ShipAddress
    end
    it "renders template new" do
      get :new
      expect(response).to render_template 'new'
    end
  end

  describe "POST #create" do
    context "if something in the cart" do
      before do 
        @book = FactoryGirl.create :book
      end
      context "with valid attributes" do
        before do
          FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id
        end
        it "creates new order" do
          expect{post :create, order: FactoryGirl.attributes_for(:order)}.to change(Order, :count).by(1)
        end
        it "redirects to newly created @order path" do  
          post :create, order: FactoryGirl.attributes_for(:order)
          expect(response).to redirect_to Order.last
        end
      end
      context "with invalid attributes" do
        before do
          FactoryGirl.create :order_item, quantity: 1, price: "invalid", book_id: @book.id, customer_id: @customer.id, order_id: @order.id
        end
        it "do not creates new bill_address" do
          expect{post :create, order: FactoryGirl.attributes_for(:order)}.to_not change(Order, :count)      
        end
        it "renders template new" do  
          post :create, order: FactoryGirl.attributes_for(:order, price: 'price')
          expect(response).to render_template 'new'
        end
      end
    end
    context "if nothing in the cart" do
      it "renders template new" do  
          post :create, order: FactoryGirl.attributes_for(:order) 
          expect(response).to render_template 'new'
        end
    end
  end

  describe "GET #show" do
    before(:each) do
      Order.stub(:find).and_return @order
    end
    it "receives find and return book" do
      expect(Order).to receive(:find).with(@order.id.to_s).and_return @order
      get :show, id: @order.id
    end
    it "assigns order" do
      get :show, id: @order.id
      expect(assigns(:order)).to eq @order
    end
    it "renders template show" do
      get :show, id: @order.id
      expect(response).to render_template("show")
    end
  end

end


