require 'spec_helper'

describe OrdersController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @order = FactoryGirl.create :order, customer_id: @customer.id
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
    sign_in @customer
  end

  describe "GET #index" do
    context "with read ability" do
      before do
        @ability.can :read, Order
      end
      it "returns an array of orders" do
        get :index 
        expect(assigns(:orders)).to eq [@order]
      end 
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Order
      end
      it "redirects to customer_session_path" do
        get :index
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, Order
      end
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
    context "without manage ability" do
      before do
        @ability.cannot :manage, Order
      end
      it "redirects to customer_session_path" do
        get :new
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, Order
      end
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
    context "without manage ability" do
      before do
        @ability.cannot :manage, Order
      end
      context "if something in the cart" do
        before do 
          @book = FactoryGirl.create :book
        end
        context "with valid attributes" do
          before do
            FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id
          end
          it "do not creates new order" do
            expect{post :create, order: FactoryGirl.attributes_for(:order)}.to_not change(Order, :count).by(1)
          end
          it "redirects to customer_session_path" do
            post :create, order: FactoryGirl.attributes_for(:order)
            expect(response).to redirect_to customer_session_path
          end
        end
        context "with invalid attributes" do
          before do
            FactoryGirl.create :order_item, quantity: 1, price: "invalid", book_id: @book.id, customer_id: @customer.id, order_id: @order.id
          end
          it "do not creates new bill_address" do
            expect{post :create, order: FactoryGirl.attributes_for(:order)}.to_not change(Order, :count)      
          end
          it "redirects to customer_session_path" do
            post :create, order: FactoryGirl.attributes_for(:order)
            expect(response).to redirect_to customer_session_path
          end
        end
      end
      context "if nothing in the cart" do
        it "redirects to customer_session_path" do
          post :create, order: FactoryGirl.attributes_for(:order)
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe "GET #show" do
    context "with read ability" do
      before do
        @ability.can :read, Order
        Order.stub(:find).and_return @order
      end
      it "receives find and return order" do
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
    context "without read ability" do
      before do
        @ability.cannot :read, Order
      end
      it "redirects_to customer_session_path" do
        get :show, id: @order.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end


