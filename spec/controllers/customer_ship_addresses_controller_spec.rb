require 'spec_helper'

describe CustomerShipAddressesController do
  before(:each) do
    create_ability!
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @customer_ship_address= FactoryGirl.create :customer_ship_address, zipcode: 12345, country: @country
    sign_in @customer
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerShipAddress
      end
      it "builds customer_ship_address if customer do not have it already" do
        get :new
        expect(assigns(:customer_ship_address)).to be_a_new CustomerShipAddress
      end
      it "renders template new if have manage ability" do
        get :new
        expect(response).to render_template 'new'
      end
      it "redirects to edit_customer_registration_path if customer already have customer_ship_address" do
        FactoryGirl.create :customer_ship_address, customer_id: @customer.id, country: @country
        get :new
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerShipAddress
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
        @customer_ship_address.update(customer_id: @customer.id)
        @ability.can :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      context 'if customer ship address within current customer' do
        it "receives find and return customer_ship_address" do
          expect(CustomerShipAddress).to receive(:find).with(@customer_ship_address.id.to_s).and_return @customer_ship_address
          get :edit, id: @customer_ship_address.id
        end
        it "assigns customer_ship_address" do
          get :edit, id: @customer_ship_address.id
          expect(assigns(:customer_ship_address)).to eq @customer_ship_address
        end
        it "renders template edit" do
          get :edit, id: @customer_ship_address.id
          expect(response).to render_template("edit")
        end
      end
      context "if customer ship address not within current customer" do
        it "redirects to root_path" do
          @customer_ship_address.update(customer_id: nil)
          get :edit, id: @customer_ship_address.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      it "redirects to root_path" do
        get :edit, id: @customer_ship_address.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerShipAddress
      end
      context "with valid attributes" do
        it "creates new customer_ship_address" do
          expect{post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id)}.to change(CustomerShipAddress, :count).by(1)
        end
        it "redirects to edit_customer_registration_path" do  
          post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new customer_ship_address" do
          expect{post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(CustomerShipAddress, :count)      
        end
        it "renders template new" do  
          post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to render_template "new"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerShipAddress
      end
      context "with valid attributes" do
        it "do not creates new customer_ship_address" do
          expect{post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id)}.to_not change(CustomerShipAddress, :count)
        end
        it "do not redirects to edit_customer_registration_path" do  
          post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new customer_ship_address" do
          expect{post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(CustomerShipAddress, :count)      
        end
        it "redirects to root_path" do  
          post :create, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      it "receives find and return customer_ship_address" do
        expect(CustomerShipAddress).to receive(:find).with(@customer_ship_address.id.to_s).and_return @customer_ship_address
        put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address)
      end
      context "with valid attributes" do
        it "updates @customer_ship_address's attributes" do
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, address: "new address")
          @customer_ship_address.reload
          expect(@customer_ship_address.address).to eq "new address"
        end
        it "redirects to edit_customer_registration_path" do  
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @customer_ship_address's attributes" do
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, zipcode: "zipcode")
          @customer_ship_address.reload
          expect(@customer_ship_address.zipcode).to_not eq "zipcode"
        end
        it "renders template edit" do  
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, zipcode: "zipcode")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      context "with valid attributes" do
        it "do not updates @customer_ship_address's attributes" do
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, address: "new address")
          @customer_ship_address.reload
          expect(@customer_ship_address.address).to_not eq "new address"
        end
        it "do not redirects to edit_customer_registration_path" do  
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @customer_ship_address's attributes" do
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, zipcode: "zipcode")
          @customer_ship_address.reload
          expect(@customer_ship_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to root_path" do  
          put :update, id: @customer_ship_address.id, customer_ship_address: FactoryGirl.attributes_for(:customer_ship_address, country: @country, zipcode: "zipcode")
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context "with manage ability" do
      before do
        @customer_ship_address.update(customer_id: @customer.id)
        @ability.can :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      context 'if customer ship address within current customer' do
        it "receives find and return customer_ship_address" do
          expect(CustomerShipAddress).to receive(:find).with(@customer_ship_address.id.to_s).and_return @customer_ship_address
          delete :destroy, id: @customer_ship_address.id
        end
        it "deletes customer_ship_address" do
          expect{delete :destroy, id: @customer_ship_address.id}.to change(CustomerShipAddress, :count).by(-1)
          delete :destroy, id: @customer_ship_address.id
        end
        it "redirects to edit_customer_registration_path" do
          delete :destroy, id: @customer_ship_address.id
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "if customer ship address not within current customer" do
        it "redirects to root_path" do
          @customer_ship_address.update(customer_id: nil)
          delete :destroy, id: @customer_ship_address.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CustomerShipAddress
        CustomerShipAddress.stub(:find).and_return @customer_ship_address
      end
      it "do not deletes customer_ship_address" do
        expect{delete :destroy, id: @customer_ship_address.id}.to_not change(CustomerShipAddress, :count)
        delete :destroy, id: @customer_ship_address.id
      end
      it "redirects to root_path" do
        delete :destroy, id: @customer_ship_address.id
        expect(response).to redirect_to root_path
      end
    end
  end
end

