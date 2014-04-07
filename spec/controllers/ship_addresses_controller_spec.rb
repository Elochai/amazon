require 'spec_helper'

describe ShipAddressesController do
  before(:each) do
    create_order!
    create_ability!
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @ship_address= FactoryGirl.create :ship_address, zipcode: 12345, country: @country
    sign_in @customer
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @ship_address.update(order_id: @order.id)
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
      it "redirects to root_path" do
        get :edit, id: @ship_address.id
        expect(response).to redirect_to root_path
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
        put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country)
      end
      context "with valid attributes" do
        it "updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, address: "new address")
          @ship_address.reload
          expect(@ship_address.address).to eq "new address"
        end
        it "redirects to order_confirm_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country)
          expect(response).to redirect_to order_confirm_path
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
        it "do not redirects to order_confirm_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country)
          expect(response).to_not redirect_to order_confirm_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @ship_address's attributes" do
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          @ship_address.reload
          expect(@ship_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to root_path" do  
          put :update, id: @ship_address.id, ship_address: FactoryGirl.attributes_for(:ship_address, country: @country, zipcode: "zipcode")
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
