require 'spec_helper'

describe ShipAddressesController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @ship_address= FactoryGirl.create :ship_address, zipcode: 12345, country: @country
    sign_in @customer
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, ShipAddress
      end
      it "builds ship_address if customer do not have it already" do
        get :new
        expect(assigns(:ship_address)).to be_a_new ShipAddress
      end
      it "renders template new if have manage ability" do
        get :new
        expect(response).to render_template 'new'
      end
      it "redirects to edit_customer_registration_path if customer already have ship_address" do
        FactoryGirl.create :ship_address, customer_id: @customer.id, country: @country
        get :new
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, ShipAddress
      end
      it "redirects to customer_session_path" do
        get :new
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @ability.can :manage, ShipAddress
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
    context "without manage ability" do
      before do
        @ability.cannot :manage, ShipAddress
        ShipAddress.stub(:find).and_return @ship_address
      end
      it "redirects to customer_session_path" do
        get :edit, id: @ship_address.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, ShipAddress
      end
      context "with valid attributes" do
        it "creates new ship_address" do
          expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id)}.to change(ShipAddress, :count).by(1)
        end
        it "redirects to edit_customer_registration_path" do  
          post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new ship_address" do
          expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(ShipAddress, :count)      
        end
        it "renders template new" do  
          post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to render_template "new"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, ShipAddress
      end
      context "with valid attributes" do
        it "do not creates new ship_address" do
          expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id)}.to_not change(ShipAddress, :count)
        end
        it "do not redirects to edit_customer_registration_path" do  
          post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new ship_address" do
          expect{post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id, zipcode: "zipcode")}.to_not change(ShipAddress, :count)      
        end
        it "redirects to customer_session_path" do  
          post :create, ship_address: FactoryGirl.attributes_for(:ship_address, country_id: @country.id, zipcode: "zipcode")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, ShipAddress
        ShipAddress.stub(:find).and_return @ship_address
      end
      it "receives find and return ship_address" do
        expect(ShipAddress).to receive(:find).with(@ship_address.id.to_s).and_return @ship_address
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address)
      end
      context "with valid attributes" do
        it "updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, address: "new address")
          @ship_address.reload
          expect(@ship_address.address).to eq "new address"
        end
        it "redirects to edit_customer_registration_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          @ship_address.reload
          expect(@ship_address.zipcode).to_not eq "zipcode"
        end
        it "renders template edit" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, ShipAddress
        ShipAddress.stub(:find).and_return @ship_address
      end
      context "with valid attributes" do
        it "do not updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, address: "new address")
          @ship_address.reload
          expect(@ship_address.address).to_not eq "new address"
        end
        it "do not redirects to edit_customer_registration_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          @ship_address.reload
          expect(@ship_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to customer_session_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context "with manage ability" do
      before do
        @ability.can :manage, ShipAddress
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
    context "without manage ability" do
      before do
        @ability.cannot :manage, ShipAddress
        ShipAddress.stub(:find).and_return @ship_address
      end
      it "do not deletes ship_address" do
        expect{delete :destroy, id: @ship_address.id}.to_not change(ShipAddress, :count)
        delete :destroy, id: @ship_address.id
      end
      it "redirects to customer_session_path" do
        delete :destroy, id: @ship_address.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end

