require 'spec_helper'

describe CustomerBillAddressesController do
  before(:each) do
    create_ability!
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @customer_bill_address= FactoryGirl.create :customer_bill_address, zipcode: 12345, country: @country
    sign_in @customer
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerBillAddress
      end
      it "builds customer_bill_address if customer do not have it already" do
        get :new
        expect(assigns(:customer_bill_address)).to be_a_new CustomerBillAddress
      end
      it "renders template new if have manage ability" do
        get :new
        expect(response).to render_template 'new'
      end
      it "redirects to edit_customer_registration_path if customer already have customer_bill_address" do
        FactoryGirl.create :customer_bill_address, customer_id: @customer.id, country: @country
        get :new
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerBillAddress
      end
      it "redirects to root_path" do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @customer_bill_address.update(customer_id: @customer.id)
        @ability.can :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      context 'if customer bill address within current customer' do
        it "receives find and return customer_bill_address" do
          expect(CustomerBillAddress).to receive(:find).with(@customer_bill_address.id.to_s).and_return @customer_bill_address
          get :edit, id: @customer_bill_address.id
        end
        it "assigns customer_bill_address" do
          get :edit, id: @customer_bill_address.id
          expect(assigns(:customer_bill_address)).to eq @customer_bill_address
        end
        it "renders template edit" do
          get :edit, id: @customer_bill_address.id
          expect(response).to render_template("edit")
        end
      end
      context "if customer bill address not within current customer" do
        it "redirects to root_path" do
          @customer_bill_address.update(customer_id: nil)
          get :edit, id: @customer_bill_address.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      it "redirects to root_path" do
        get :edit, id: @customer_bill_address.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerBillAddress
      end
      context "with valid attributes" do
        it "creates new customer_bill_address" do
          expect{post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id)}.to change(CustomerBillAddress, :count).by(1)
        end
        it "redirects to edit_customer_registration_path" do  
          post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id, order: @order)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new customer_bill_address" do
          expect{post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(CustomerBillAddress, :count)      
        end
        it "renders template new" do  
          post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to render_template "new"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerBillAddress
      end
      context "with valid attributes" do
        it "do not creates new customer_bill_address" do
          expect{post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id)}.to_not change(CustomerBillAddress, :count)
        end
        it "do not redirects to edit_customer_registration_path" do  
          post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new customer_bill_address" do
          expect{post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(CustomerBillAddress, :count)      
        end
        it "redirects to root_path" do  
          post :create, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      it "receives find and return customer_bill_address" do
        expect(CustomerBillAddress).to receive(:find).with(@customer_bill_address.id.to_s).and_return @customer_bill_address
        put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country)
      end
      context "with valid attributes" do
        it "updates @customer_bill_address's attributes" do
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, address: "new address")
          @customer_bill_address.reload
          expect(@customer_bill_address.address).to eq "new address"
        end
        it "redirects to edit_customer_registration_path" do  
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @customer_bill_address's attributes" do
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, zipcode: "zipcode")
          @customer_bill_address.reload
          expect(@customer_bill_address.zipcode).to_not eq "zipcode"
        end
        it "renders template edit" do  
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, zipcode: "zipcode")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      context "with valid attributes" do
        it "do not updates @customer_bill_address's attributes" do
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, address: "new address")
          @customer_bill_address.reload
          expect(@customer_bill_address.address).to_not eq "new address"
        end
        it "do not redirects to edit_customer_registration_path" do  
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @customer_bill_address's attributes" do
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, zipcode: "zipcode")
          @customer_bill_address.reload
          expect(@customer_bill_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to root_path" do  
          put :update, id: @customer_bill_address.id, customer_bill_address: FactoryGirl.attributes_for(:customer_bill_address, country: @country, zipcode: "zipcode")
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context "with manage ability" do
      before do
        @customer_bill_address.update(customer_id: @customer.id)
        @ability.can :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      context "if customer bill address within current customer" do
        it "receives find and return customer_bill_address" do
          expect(CustomerBillAddress).to receive(:find).with(@customer_bill_address.id.to_s).and_return @customer_bill_address
          delete :destroy, id: @customer_bill_address.id
        end
        it "deletes customer_bill_address" do
          expect{delete :destroy, id: @customer_bill_address.id}.to change(CustomerBillAddress, :count).by(-1)
          delete :destroy, id: @customer_bill_address.id
        end
        it "redirects to edit_customer_registration_path" do
          delete :destroy, id: @customer_bill_address.id
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "if customer bill address not within current customer" do
        it "redirects to root_path" do
          @customer_bill_address.update(customer_id: nil)
          delete :destroy, id: @customer_bill_address.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerBillAddress
        CustomerBillAddress.stub(:find).and_return @customer_bill_address
      end
      it "do not deletes customer_bill_address" do
        expect{delete :destroy, id: @customer_bill_address.id}.to_not change(CustomerBillAddress, :count)
        delete :destroy, id: @customer_bill_address.id
      end
      it "redirects to root_path" do
        delete :destroy, id: @customer_bill_address.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
