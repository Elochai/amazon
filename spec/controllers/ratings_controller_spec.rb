require 'spec_helper'

describe RatingsController do
  before(:each) do
    @book = FactoryGirl.create :book
    @customer = FactoryGirl.create :customer
    @rating= FactoryGirl.create :rating
    sign_in @customer
  end
  describe "POST #create" do
    context "with valid attributes" do
      it "creates new rating" do
        expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating)}.to change(Rating, :count).by(1)
      end
      it "redirects to book_path" do  
        post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating)
        expect(response).to redirect_to Book.last
      end
    end
    context "with invalid attributes" do
      it "do not creates new rating" do
        expect{post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)}.to_not change(Rating, :count)      
      end
      it "redirects to book_path" do  
        post :create, book_id: @book.id, rating: FactoryGirl.attributes_for(:rating, rating: 0)
        expect(response).to redirect_to Book.last
      end
    end
  end
end