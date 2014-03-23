class BooksController < ApplicationController
  load_and_authorize_resource
  # GET /books
  # GET /books.json
  def index
    @filterrific = Filterrific.new(Book, params[:filterrific])
    @books = Book.filterrific_find(@filterrific).page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def top_rated
    @books = Book.top_rated
  end
 
  # GET /books/1
  # GET /books/1.json
  def show
    @current_book = Book.find(@book.id)
    @rating = @book.ratings.new
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
