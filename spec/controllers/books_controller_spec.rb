require 'spec_helper'

describe BooksController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
    sign_in @customer
  end

  describe "GET #index" do
    context "with read ability" do
      before do
        @ability.can :read, Book
      end
      it "returns an array of books" do
        get :index 
        expect(assigns(:books)).to eq [@book]
      end 
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Book
      end
      it "redirects to customer_session_path" do
        get :index
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #show" do
    context "with read ability" do
      before do
        @ability.can :read, Book
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
    context "without read ability" do
      before do
        @ability.cannot :read, Book
      end
      it "redirects to customer_session_path" do
        get :show, id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #add_to_order" do
    context "with add_to_order ability" do
      before do
        @ability.can :add_to_order, Book
        Book.stub(:find).and_return @book
      end
      it "receives find and return book" do
        expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
        get :add_to_order, id: @book.id
      end
      it "creates new order_item if it is not in the cart already" do
        expect {post :add_to_order, id: @book.id, quantity: 1}.to change(OrderItem, :count).by(1)
      end
      it "updates order_item quantity by 1 if it is in the cart already" do
        @oi = FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id, quantity: 1
        post :add_to_order, id: @book.id, quantity: 1
        @oi.reload
        expect(@oi.quantity).to eq(2)
      end
      it "redirects to new_order_path" do
        post :add_to_order, id: @book.id
        expect(response).to redirect_to new_order_path
      end
    end
    context "without add_to_order ability" do
      before do
        @ability.cannot :add_to_order, Book
      end
      it "do not creates new order_item if it is not in the cart already" do
        expect {post :add_to_order, id: @book.id, quantity: 1}.to_not change(OrderItem, :count)
      end
      it "do not updates order_item quantity by 1 if it is in the cart already" do
        @oi = FactoryGirl.create :order_item, customer_id: @customer.id, book_id: @book.id, quantity: 1
        post :add_to_order, id: @book.id, quantity: 1
        @oi.reload
        expect(@oi.quantity).to_not eq(2)
      end
      it "redirects to customer_session_path" do
        post :add_to_order, id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #add_wish" do
    context "with add_wish ability" do
      before do
        @ability.can :add_wish, Book
        Book.stub(:find).and_return @book
      end
      it "receives find and return book" do
        expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
        get :add_wish, id: @book.id
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
    context "without add_wish ability" do
      before do
        @ability.cannot :add_wish, Book
      end
      it "do not adds current customer to book wishers list" do
        post :add_wish, id: @book.id
        expect(@book.wishers).to_not eq [@customer]
      end
      it "redirects to customer_session_path" do
        post :add_wish, id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #remove_wish" do
    context "with remove_wish ability" do
      before do
        @ability.can :remove_wish, Book
        Book.stub(:find).and_return @book
      end
      it "receives find and return book" do
        expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
        get :remove_wish, id: @book.id
      end
      it "removes current customer from book wishers list" do
        @book.wishers << @customer
        post :remove_wish, id: @book.id
        expect(@book.wishers).to eq []
      end
      it "redirects to book_path" do
        post :remove_wish, id: @book.id
        expect(response).to redirect_to book_path(@book)
      end
    end
    context "without remove_wish ability" do
      before do
        @ability.cannot :remove_wish, Book
      end
      it "do not removes current customer from book wishers list" do
        @book.wishers << @customer
        post :remove_wish, id: @book.id
        expect(@book.wishers).to_not eq []
      end
      it "redirects to customer_session_path" do
        post :remove_wish, id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #wishers" do
    context "with wishers ability" do
      before do
        @ability.can :wishers, Book
        Book.stub(:find).and_return @book
      end
      it "receives find and return book" do
        expect(Book).to receive(:find).with(@book.id.to_s).and_return @book
        get :wishers, id: @book.id
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
    context "without wishers ability" do
      before do
        @ability.cannot :wishers, Book
      end
      it "do not returns an array of books wishers" do
        @book.wishers << @customer
        wisher = @book.wishers
        post :wishers, id: @book.id
        expect(assigns(:wishers)).to_not eq wisher
      end
      it "redirects to customer_session_path" do
        post :wishers, id: @book.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #author_filter" do
    context "with author_filter ability" do
      before(:each) do
        @ability.can :author_filter, Book
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
    context "without author_filter ability" do
      before(:each) do
        @ability.cannot :author_filter, Book
        @author = FactoryGirl.create :author
        @book.author_id = @author.id
        @book.save
        Author.stub(:find).and_return @author
      end
      it "do not returns an array of found author books" do
        get :author_filter, author_id: @author.id
        expect(assigns(:books)).to_not eq [@book]
      end
      it "redirects to customer_session_path" do
        get :author_filter, author_id: @author.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #category_filter" do
    context "with category_filter ability" do
      before(:each) do
        @ability.can :category_filter, Book
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
    context "without category_filter ability" do
      before(:each) do
        @ability.cannot :category_filter, Book
        @category = FactoryGirl.create :category
        @book.category_id = @category.id
        @book.save
        Category.stub(:find).and_return @category
      end
      it "do not returns an array of found category books" do
        get :category_filter, category_id: @category.id
        expect(assigns(:books)).to_not eq [@book]
      end
      it "redirects to customer_session_path" do
        get :category_filter, category_id: @category.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end

