class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy, :approve_review]
  before_action :authenticate_customer!
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = current_customer.ratings
  end
 
  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end
 
  # GET /ratings/new
  def new
    @book = Book.find(@book.id)
    @rating = @book.ratings.new
  end
 
  # GET /ratings/1/edit
  def edit
    if current_customer.admin == true
    end
  end
 
  # POST /ratings
  # POST /ratings.json
  def create
    @book = Book.find(params[:book_id])
    @rating = @book.ratings.new(rating_params)
    @rating.customer_id = current_customer.id
    respond_to do |format|
      if Rating.where(customer_id: current_customer.id, book_id: @book.id).empty?
        if @rating.save
          format.html { redirect_to :back, notice: 'Successfully added.' }
          format.json { render action: 'show', status: :created, location: @rating }
        else
          format.html { redirect_to :back, alert: 'An error has occured while adding your rating' }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
        format.html { redirect_to :back, alert: 'You have already rated added your review for this book!' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to :back, alert: 'You have already rated added your review for this book!' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    if current_customer.admin == true
      respond_to do |format|
        if @rating.update(rating_params)
          format.html { redirect_to @rating, notice: 'Review was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    if current_customer.admin == true
      @rating.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    end
  end

  def approve_review
    if current_customer.admin == true
      @rating.approve!
      redirect_to :back
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :text)
    end
end

