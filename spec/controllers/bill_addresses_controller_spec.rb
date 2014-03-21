require 'spec_helper'

describe BillAddressesController do
  before(:each) do
    create_order!
    create_ability!
    @customer = FactoryGirl.create :customer
    @country = FactoryGirl.create :country
    @bill_address= FactoryGirl.create :bill_address, zipcode: 12345, country: @country
    sign_in @customer
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @bill_address.update(order_id: @order.id)
        @ability.can :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      context 'if bill address within current order' do
        it "receives find and return bill_address" do
          expect(BillAddress).to receive(:find).with(@bill_address.id.to_s).and_return @bill_address
          get :edit, id: @bill_address.id
        end
        it "assigns bill_address" do
          get :edit, id: @bill_address.id
          expect(assigns(:bill_address)).to eq @bill_address
        end
        it "renders template edit" do
          get :edit, id: @bill_address.id
          expect(response).to render_template("edit")
        end
      end
      context "if bill address not within current order" do
        it "redirects to root_path" do
          @bill_address.update(order_id: nil)
          get :edit, id: @bill_address.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "redirects to customer_session_path" do
        get :edit, id: @bill_address.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "receives find and return bill_address" do
        expect(BillAddress).to receive(:find).with(@bill_address.id.to_s).and_return @bill_address
        put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country)
      end
      context "with valid attributes" do
        it "updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, address: "new address")
          @bill_address.reload
          expect(@bill_address.address).to eq "new address"
        end
        it "redirects to order_confirm_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country)
          expect(response).to redirect_to order_confirm_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, zipcode: "zipcode")
          @bill_address.reload
          expect(@bill_address.zipcode).to_not eq "zipcode"
        end
        it "renders template edit" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, zipcode: "zipcode")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      context "with valid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, address: "new address")
          @bill_address.reload
          expect(@bill_address.address).to_not eq "new address"
        end
        it "do not redirects to order_confirm_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country)
          expect(response).to_not redirect_to order_confirm_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, zipcode: "zipcode")
          @bill_address.reload
          expect(@bill_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to customer_session_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, country: @country, zipcode: "zipcode")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end
end
