require 'spec_helper'

describe CreditCardsController do
  before(:each) do
    create_order!
    create_ability!
    @customer = FactoryGirl.create :customer
    @credit_card = FactoryGirl.create :credit_card, cvv: 123
    sign_in @customer
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, CreditCard
      end
      it "builds credit_card if customer do not have it already" do
        get :new
        expect(assigns(:credit_card)).to be_a_new CreditCard
      end
      it "renders template new if have manage ability" do
        @order.update(checkout_step: 4)
        get :new
        expect(response).to render_template 'new'
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CreditCard
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
        @credit_card.update(order_id: @order.id)
        @ability.can :manage, CreditCard
        CreditCard.stub(:find).and_return @credit_card
      end
      context "if credit card is within current order" do
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
      context "if credit card is not within current order" do
        it "renders redirects to root_path" do
          @credit_card.update(order_id: nil)
          get :edit, id: @credit_card.id
          expect(response).to redirect_to root_path
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CreditCard
        CreditCard.stub(:find).and_return @credit_card
      end
      it "redirects to customer_session_path" do
        get :edit, id: @credit_card.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @order.update(checkout_step: 4)
        @ability.can :manage, CreditCard
      end
      context "with valid attributes" do
        it "creates new credit_card" do
          expect{post :create, credit_card: FactoryGirl.attributes_for(:credit_card)}.to change(CreditCard, :count).by(1)
        end
        it "redirects to next step" do  
          post :create, credit_card: FactoryGirl.attributes_for(:credit_card)
          expect(response).to redirect_to step_path('5')
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
    context "without manage ability" do
      before do
        @order.update(checkout_step: 4)
        @ability.cannot :manage, CreditCard
      end
      context "with valid attributes" do
        it "do not creates new credit_card" do
          expect{post :create, credit_card: FactoryGirl.attributes_for(:credit_card)}.to_not change(CreditCard, :count)
        end
        it "do not redirects to next step" do  
          post :create, credit_card: FactoryGirl.attributes_for(:credit_card)
          expect(response).to_not redirect_to step_path('5')
        end
      end
      context "with invalid attributes" do
        it "do not creates new credit_card" do
          expect{post :create, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")}.to_not change(CreditCard, :count)      
        end
        it "redirects to customer_session_path" do  
          post :create, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, CreditCard
        CreditCard.stub(:find).and_return @credit_card
      end
      it "receives find and return credit_card" do
        expect(CreditCard).to receive(:find).with(@credit_card.id.to_s).and_return @credit_card
        put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card)
      end
      context "with valid attributes" do
        it "updates @credit_card's attributes" do
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: 666)
          @credit_card.reload
          expect(@credit_card.cvv).to eq 666
        end
        it "redirects to order_confirm_path" do  
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card)
          expect(response).to redirect_to order_confirm_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @credit_card's attributes" do
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
          @credit_card.reload
          expect(@credit_card.cvv).to_not eq "cvv"
        end
        it "renders template edit" do  
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, CreditCard
        CreditCard.stub(:find).and_return @credit_card
      end
      context "with valid attributes" do
        it "do not updates @credit_card's attributes" do
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: 666)
          @credit_card.reload
          expect(@credit_card.cvv).to_not eq 666
        end
        it "do not redirects to order_confirm_path" do  
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card)
          expect(response).to_not redirect_to order_confirm_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @credit_card's attributes" do
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
          @credit_card.reload
          expect(@credit_card.cvv).to_not eq "cvv"
        end
        it "redirects to customer_session_path" do  
          put :update, id: @credit_card.id, credit_card: FactoryGirl.attributes_for(:credit_card, cvv: "cvv")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end
end

