require 'spec_helper'

describe BooksController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book
    sign_in @customer
  end

  describe "GET #index" do
    it "returns an array of books" do
      get :index 
      expect(assigns(:books)).to eq [@book]
    end 
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    before(:each) do
      Book.stub(:find).and_return @book
    end
    it "receives find and return book" do
      expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
      get :show, id: @book.id
    end
    it "assigns book" do
      get :show, id: @book.id
      expect(assigns(:book)).to eq @book
    end
    it "builds rating" do
      get :show, id: @book.id
      expect(assigns(:rating)).to be_a_new Rating
    end
    it "renders template show" do
      get :show, id: @book.id
      expect(response).to render_template("show")
    end
  end

  describe "POST #add_to_order" do
    before(:each) do
      Book.stub(:find).and_return @book
    end
    it "receives find and return book" do
      expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
      get :show, id: @book.id
    end
    it "creates new order_item if it is not in the cart already" do
      expect {post :add_to_order, id: @book.id}.to change(OrderItem, :count).by(1)
    end
    it "updates order_item quantity by 1 if it is in the cart already" do
      @oi = FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id, quantity: 1
      post :add_to_order, id: @book.id
      @oi.reload
      expect(@oi.quantity).to eq(2)
    end
    it "redirects to new_order_path" do
      post :add_to_order, id: @book.id
      expect(response).to redirect_to new_order_path
    end
  end
  describe "POST #add_wish" do
    before(:each) do
      Book.stub(:find).and_return @book
    end
    it "receives find and return book" do
      expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
      get :show, id: @book.id
    end
    it "adds current customer to book wishers list" do
      post :add_wish, id: @book.id
      expect(@book.wishers).to eq [@customer]
    end
    it "do not adds current customer to book wishers list if he wish this book already" do
      @book.wishers << @customer
      expect{post :add_wish, id: @book.id}.to_not change(@book.wishers, :count)
    end
    it "redirects to book_path" do
      post :add_wish, id: @book.id
      expect(response).to redirect_to book_path(@book)
    end
  end
  describe "POST #remove_wish" do
    before(:each) do
      Book.stub(:find).and_return @book
    end
    it "receives find and return book" do
      expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
      get :show, id: @book.id
    end
    it "removes current customer from book wishers list" do
      post :remove_wish, id: @book.id
      expect(@book.wishers).to eq []
    end
    it "redirects to book_path" do
      post :remove_wish, id: @book.id
      expect(response).to redirect_to book_path(@book)
    end
  end
  describe "GET #wishers" do
    before(:each) do
      Book.stub(:find).and_return @book
    end
    it "receives find and return book" do
      expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
      get :show, id: @book.id
    end
    it "returns an array of books wishers" do
      @book.wishers << @customer
      wisher = @book.wishers
      post :wishers, id: @book.id
      expect(assigns(:wishers)).to eq wisher
    end
    it "renders template wishers" do
      post :wishers, id: @book.id
      expect(response).to render_template("wishers")
    end
  end
  describe "GET #author_filter" do
    before(:each) do
      @author = FactoryGirl.create :author
      @book.author_id = @author.id
      @book.save
      Author.stub(:find).and_return @author
    end
    it "receives find and return author" do
      expect(Author).to receive(:find).with(@author.id.to_s).and_return @author
      get :author_filter, author_id: @author.id
    end
    it "returns an array of found author books" do
      get :author_filter, author_id: @author.id
      expect(assigns(:books)).to eq [@book]
    end
    it "renders template author_filter" do
      get :author_filter, author_id: @author.id
      expect(response).to render_template("author_filter")
    end
  end
  describe "GET #category_filter" do
    before(:each) do
      @category = FactoryGirl.create :category
      @book.category_id = @category.id
      @book.save
      Category.stub(:find).and_return @category
    end
    it "receives find and return category" do
      expect(Category).to receive(:find).with(@category.id.to_s).and_return @category
      get :category_filter, category_id: @category.id
    end
    it "returns an array of found category books" do
      get :category_filter, category_id: @category.id
      expect(assigns(:books)).to eq [@book]
    end
    it "renders template category_filter" do
      get :category_filter, category_id: @category.id
      expect(response).to render_template("category_filter")
    end
  end
end

