require 'spec_helper'

describe CreditCardsController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @credit_card= FactoryGirl.create :credit_card, cvv: 123
    sign_in @customer
  end

  describe "GET #new" do
    it "builds credit_card if customer do not have it already" do
      get :new
      expect(assigns(:credit_card)).to be_a_new CreditCard
    end
    it "redirects to edit_customer_registration_path if customer already have credit_card" do
      FactoryGirl.create :credit_card, customer_id: @customer.id
      get :new
      expect(response).to redirect_to edit_customer_registration_path
    end
  end

  describe "GET #edit" do
    before(:each) do
      CreditCard.stub(:find).and_return @credit_card
    end
    it "receives find and return credit_card" do
      expect(CreditCard).to receive(:find).with(@credit_card.id.to_s).and_return @credit_card
      get :edit, id: @credit_card.id
    end
    it "assigns credit_card" do
      get :edit, id: @credit_card.id
      expect(assigns(:credit_card)).to eq @credit_card
    end
    it "renders template edit" do
      get :edit, id: @credit_card.id
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates new credit_card" do
        expect{post :create, credit_card: FactoryGirl.attributes_for(:credit_card)}.to change(CreditCard, :count).by(1)
      end
      it "redirects to edit_customer_registration_path" do  
        post :create, credit_card: FactoryGirl.attributes_for(:credit_card)
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "with invalid attributes" do
      it "do not creates new credit_card" do
        expect{post :create, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")}.to_not change(CreditCard, :count)      
      end
      it "renders template new" do  
        post :create, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
        expect(response).to render_template "new"
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      CreditCard.stub(:find).and_return @credit_card
    end
    it "receives find and return credit_card" do
      expect(CreditCard).to receive(:find).with(@credit_card.id.to_s).and_return @credit_card
      put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card)
    end
    context "with valid attributes" do
      it "updates @credit_card's attributes" do
        put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: 555)
        @credit_card.reload
        expect(@credit_card.cvv).to eq 555
      end
      it "redirects to edit_customer_registration_path" do  
        put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card)
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "with invalid attributes" do
      it "do not updates @credit_card's attributes" do
        put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: 'cvv')
        @credit_card.reload
        expect(@credit_card.cvv).to_not eq 'cvv'
      end
      it "renders template edit" do  
        put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
        expect(response).to render_template "edit"
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      CreditCard.stub(:find).and_return @credit_card
    end
    it "receives find and return credit_card" do
      expect(CreditCard).to receive(:find).with(@credit_card.id.to_s).and_return @credit_card
      delete :destroy, id: @credit_card.id
    end
    it "deletes credit_card" do
      expect{delete :destroy, id: @credit_card.id}.to change(CreditCard, :count).by(-1)
      delete :destroy, id: @credit_card.id
    end
    it "redirects to edit_customer_registration_path if customer already have credit_card" do
      delete :destroy, id: @credit_card.id
      expect(response).to redirect_to edit_customer_registration_path
    end
  end
end
