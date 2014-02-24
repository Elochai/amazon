class BooksController < ApplicationController
  before_filter :authenticate_customer!, only: [:add_to_order, :add_wish, :remove_wish]
  load_and_authorize_resource
  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end
 
  # GET /books/1
  # GET /books/1.json
  def show
    @current_book = Book.find(@book.id)
    @rating = @book.ratings.new
  end

  def add_to_order
    if current_customer.order_items.in_cart_with(@book).empty?
      current_customer.order_items.create(book_id: @book.id, quantity: params[:quantity])
    else
      current_customer.order_items.find_by(order_id: nil, book_id: @book.id).increase_quantity!(params[:quantity])
    end
    redirect_to new_order_path
  end

  def author_filter
    @author = Author.find(params[:author_id])
    @books = Book.by_author(@author)
  end
 
  def category_filter
    @category = Category.find(params[:category_id])
    @books = Book.by_category(@category)
  end

  def add_wish
    @book.wishers << current_customer unless current_customer.wishes.include?(@book)
    redirect_to book_path(@book), notice: t(:book_suc_add_wish)
  end

  def remove_wish
    @book.wishers.delete(current_customer)
    redirect_to book_path(@book), notice: t(:book_suc_delete_wish)
  end

  def wishers
    @wishers = @book.wishers
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
end
