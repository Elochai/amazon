require 'spec_helper'

describe OrdersController do
  before(:each) do
    create_order!
    create_ability!
    @customer = FactoryGirl.create :customer
    @order_with_customer = FactoryGirl.create :order, customer: @customer
    sign_in @customer
  end

  describe "GET #index" do
    context "with read ability" do
      before do
        @ability.can :read, Order
      end
      it "returns an array of current customer orders" do
        get :index 
        expect(assigns(:orders)).to eq [@order_with_customer]
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

  describe "GET #show" do
    context "with read ability" do
      before do
        @ability.can :read, Order
        Order.stub(:find).and_return @order_with_customer
      end
      context 'if order within current customer' do
        it "receives find and return order" do
          expect(Order).to receive(:find).with(@order_with_customer.id.to_s).and_return @order_with_customer
          get :show, id: @order_with_customer.id
        end
        it "assigns order" do
          get :show, id: @order_with_customer.id
          expect(assigns(:order)).to eq @order_with_customer
        end
        it "renders template show" do
          get :show, id: @order_with_customer.id
          expect(response).to render_template("show")
        end
      end
      context "if order not within current customer" do
        it "redirects to root_path" do
          @order_with_customer.update(customer_id: nil)
          get :show, id: @order_with_customer.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Order
      end
      it "redirects_to customer_session_path" do
        get :show, id: @order_with_customer.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #update_with_coupon" do
    before do
      @coupon = FactoryGirl.create :coupon
    end
    context "with update_with_coupon ability" do
      before do
        @ability.can :update_with_coupon, Order
      end
      context "with valid coupon" do
        it "updates current order with coupon" do
          post :update_with_coupon, coupon: @coupon.number
          expect(@order.reload.coupon_id).to eq(@coupon.id)
        end
        it "redirects to order_items_path" do
          post :update_with_coupon, coupon: @coupon.number
          expect(response).to redirect_to order_items_path
        end
      end
      context "with invalid coupon" do
        it "do not updates current order with coupon" do
          expect{post :update_with_coupon, coupon: "invalid"}.to_not change(@order, :coupon_id)
        end
        it "redirects to order_items_path" do
          post :update_with_coupon, coupon: "invalid"
          expect(response).to redirect_to order_items_path
        end
      end
    end
    context "without update_with_coupon ability" do
      before do
        @ability.cannot :update_with_coupon, Order
      end
      it "do not updates current order with coupon" do
          expect{post :update_with_coupon, coupon: @coupon.number}.to_not change(@order, :coupon_id)
        end
      it "redirects_to customer_session_path" do
        post :update_with_coupon, coupon: @coupon.number
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #remove_coupon" do
    context "with remove_coupon ability" do
      before do
        @ability.can :remove_coupon, Order
      end
      it "deletes coupon_id from current order" do
        @order.update(coupon_id: 1)
        post :remove_coupon
        expect(@order.reload.coupon_id).to eq(nil)
      end
      it "redirects to order_items_path" do
        post :remove_coupon
        expect(response).to redirect_to order_items_path
      end
    end
    context "without remove_coupon ability" do
      before do
        @ability.cannot :remove_coupon, Order
      end
      it "do not deletes coupon_id from current order" do
        @order.update(coupon_id: 1)
        post :remove_coupon
        expect(@order.reload.coupon_id).to eq(1)
      end
      it "redirects_to customer_session_path" do
        post :remove_coupon
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #delivery" do
    context "with delivery ability" do
      before do
        @ability.can :delivery, Order
      end
      it "renders template delivery" do
        @order.update(checkout_step: 3)
        get :delivery
        expect(response).to render_template("delivery")
      end
    end
    context "without delivery ability" do
      before do
        @ability.cannot :delivery, Order
      end
      it "do not renders template delivery" do
        get :delivery
        expect(response).to_not render_template("delivery")
      end
      it "redirects_to customer_session_path" do
        get :delivery
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #edit_delivery" do
    context "with edit_delivery ability" do
      before do
        @ability.can :edit_delivery, Order
      end
      it "renders template edit_delivery" do
        get :edit_delivery
        expect(response).to render_template("edit_delivery")
      end
    end
    context "without edit_delivery ability" do
      before do
        @ability.cannot :edit_delivery, Order
      end
      it "do not renders template edit_delivery" do
        get :edit_delivery
        expect(response).to_not render_template("edit_delivery")
      end
      it "redirects_to customer_session_path" do
        get :edit_delivery
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #add_delivery" do
    before do
      @order.update(checkout_step: 3)
      @delivery = FactoryGirl.create :delivery
    end
    context "with add_delivery ability" do
      before do
        @ability.can :add_delivery, Order
      end
      context "with valid delivery" do
        it "updates current order with delivery" do
          post :add_delivery, delivery_id: @delivery.id
          expect(@order.reload.delivery_id).to eq(@delivery.id)
        end
        it "redirects to next step" do
          post :add_delivery, delivery_id: @delivery.id
          expect(response).to redirect_to step_path(4)
        end
      end
      context "with invalid delivery" do
        it "do not updates current order with delivery" do
          expect{post :add_delivery, delivery_id: "invalid"}.to_not change(@order, :delivery_id)
        end
        it "redirects to order_delivery_path" do
          post :add_delivery, delivery_id: "invalid"
          expect(response).to redirect_to order_delivery_path
        end
      end
    end
    context "without add_delivery ability" do
      before do
        @ability.cannot :add_delivery, Order
      end
      it "do not updates current order with coupon" do
          expect{post :add_delivery, delivery_id: @delivery.id}.to_not change(@order, :delivery_id)
        end
      it "redirects_to customer_session_path" do
        post :add_delivery, delivery_id: @delivery.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #place" do
    context "with place ability" do
      before do
        @order.update(checkout_step: 5)
        @ability.can :place, Order
      end
      it "calls to_queue! method on current_order record" do
        expect_any_instance_of(Order).to receive(:to_queue!).with(@customer)
        get :place
      end
      it "deletes cookie with current_order" do
        get :place
        expect(cookies).to_not include :current_order
      end
      it "redirects to newly created order" do
        get :place
        expect(response).to redirect_to order_path(@order)
      end
    end
    context "without place ability" do
      before do
        @order.update(checkout_step: 5)
        @ability.cannot :place, Order
      end
      it "redirects to customer_session_path" do
        get :place
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #next_step" do
    context "with next_step ability" do
      before do
        @ability.can :next_step, Order
      end
      it "redirects to new_address_path if params = 2" do
        get :next_step, step: '2'
        expect(response).to redirect_to new_address_path
      end
      it "redirects to order_delivery_path if params = 3" do
        get :next_step, step: '3'
        expect(response).to redirect_to order_delivery_path
      end
      it "redirects to new_credit_card_path if params = 4" do
        get :next_step, step: '4'
        expect(response).to redirect_to new_credit_card_path
      end
      it "redirects to order_confirm_path if params = 5" do
        get :next_step, step: '5'
        expect(response).to redirect_to order_confirm_path
      end
    end
    context "without place ability" do
      before do
        @ability.cannot :next_step, Order
      end
      it "redirects to customer_session_path" do
        get :next_step, step: '4'
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end


