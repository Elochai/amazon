require 'spec_helper'

describe ShipAddressesController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @ship_address= FactoryGirl.create :ship_address, zipcode: 12345
    sign_in @customer
  end

  describe "GET #new" do
    it "builds ship_address if customer do not have it already" do
      get :new
      expect(assigns(:ship_address)).to be_a_new ShipAddress
    end
    it "redirects to edit_customer_registration_path if customer already have ship_address" do
      FactoryGirl.create :ship_address, customer_id: @customer.id
      get :new
      expect(response).to redirect_to edit_customer_registration_path
    end
  end

  describe "GET #edit" do
    before(:each) do
      ShipAddress.stub(:find).and_return @ship_address
    end
    it "receives find and return ship_address" do
      expect(ShipAddress).to receive(:find).with(@ship_address.id.to_s).and_return @ship_address
      get :edit, id: @ship_address.id
    end
    it "assigns ship_address" do
      get :edit, id: @ship_address.id
      expect(assigns(:ship_address)).to eq @ship_address
    end
    it "renders template edit" do
      get :edit, id: @ship_address.id
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates new ship_address" do
        expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address)}.to change(ShipAddress, :count).by(1)
      end
      it "redirects to edit_customer_registration_path" do  
        post :create, ship_address: FactoryGirl.attributes_for(:ship_address)
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "with invalid attributes" do
      it "do not creates new ship_address" do
        expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address, zipcode: "zipcode")}.to_not change(ShipAddress, :count)      
      end
      it "renders template new" do  
        post :create, ship_address: FactoryGirl.attributes_for(:ship_address, zipcode: "zipcode")
        expect(response).to render_template "new"
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      ShipAddress.stub(:find).and_return @ship_address
    end
    it "receives find and return ship_address" do
      expect(ShipAddress).to receive(:find).with(@ship_address.id.to_s).and_return @ship_address
      put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address)
    end
    context "with valid attributes" do
      it "updates @ship_address's attributes" do
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, address: "new address")
        @ship_address.reload
        expect(@ship_address.address).to eq "new address"
      end
      it "redirects to edit_customer_registration_path" do  
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address)
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "with invalid attributes" do
      it "do not updates @ship_address's attributes" do
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, zipcode: "zipcode")
        @ship_address.reload
        expect(@ship_address.zipcode).to_not eq "zipcode"
      end
      it "renders template edit" do  
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, zipcode: "zipcode")
        expect(response).to render_template "edit"
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      ShipAddress.stub(:find).and_return @ship_address
    end
    it "receives find and return ship_address" do
      expect(ShipAddress).to receive(:find).with(@ship_address.id.to_s).and_return @ship_address
      delete :destroy, id: @ship_address.id
    end
    it "deletes ship_address" do
      expect{delete :destroy, id: @ship_address.id}.to change(ShipAddress, :count).by(-1)
      delete :destroy, id: @ship_address.id
    end
    it "redirects to edit_customer_registration_path if customer already have ship_address" do
      delete :destroy, id: @ship_address.id
      expect(response).to redirect_to edit_customer_registration_path
    end
  end
end
