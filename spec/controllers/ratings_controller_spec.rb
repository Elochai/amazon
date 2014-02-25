require 'spec_helper'

describe RatingsController do
  before(:each) do
    @book = FactoryGirl.create :book
    @customer = FactoryGirl.create :customer
    @rating= FactoryGirl.create :rating, book_id: @book.id
    sign_in @customer
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, Rating
      end
      context "with valid attributes" do
        it "creates new rating" do
          expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating)}.to change(Rating, :count).by(1)
        end
        it "redirects to book_path" do  
          post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating)
          expect(response).to redirect_to book_path(@book)
        end
      end
      context "with invalid attributes" do
        it "do not creates new rating" do
          expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)}.to_not change(Rating, :count)      
        end
        it "redirects to book_path" do  
          post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)
          expect(response).to redirect_to book_path(@book)
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, Rating
      end
      context "with valid attributes" do
        it "do not creates new rating" do
          expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating)}.to_not change(Rating, :count)
        end
        it "redirects to customer_session_path" do  
          post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)
          expect(response).to redirect_to customer_session_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new rating" do
          expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)}.to_not change(Rating, :count)      
        end
        it "redirects to customer_session_path" do  
          post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end
end