require 'spec_helper'

describe AddressesController do
  before(:each) do
    create_order!
    create_ability!
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @address= FactoryGirl.create :address, zipcode: 12345, country: @country
    sign_in @customer
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @order.update(checkout_step: 2)
        @ability.can :manage, Address
      end
      it "builds new bill address" do
        get :new
        expect(assigns(:bill_address)).to be_a_new BillAddress
      end
      it "builds new ship address" do
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
        @order.update(checkout_step: 2)
        @ability.cannot :manage, Address
      end
      it "redirects to root_path" do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        sign_out @customer
        @order.update(checkout_step: 2)
        @ability.can :manage, Address
      end
      context "with valid attributes" do
        it "creates new addresses" do
          expect{post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order)}}.to change(Address, :count).by(2)
        end
        it "redirects to next_step" do  
          post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order)}  
          expect(response).to redirect_to step_path('3')
        end
      end
      context "with invalid attributes" do
        it "do not creates new addresses" do
          expect{post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, zipcode: 1, order: @order)}}.to_not change(Address, :count)      
        end
        it "renders template new" do  
          post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, zipcode: 1, order: @order)}
          expect(response).to render_template "new"
        end
      end
    end
    context "without manage ability" do
      before do
        @order.update(checkout_step: 2)
        @ability.cannot :manage, Address
      end
      context "with valid attributes" do
        it "do not creates new addresses" do
          expect{post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order)}}.to_not change(Address, :count)
        end
        it "do not redirects to next_step" do  
          post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order)}
          expect(response).to_not redirect_to step_path('3')
        end
      end
      context "with invalid attributes" do
        it "do not creates new addresses" do
          expect{post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, zipcode: 1, order: @order)}}.to_not change(Address, :count)      
        end
        it "redirects to root_path" do  
          post :create, order: {bill_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, order: @order), ship_address_attributes: FactoryGirl.attributes_for(:address, country_id: @country.id, zipcode: 1, order: @order)}
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
