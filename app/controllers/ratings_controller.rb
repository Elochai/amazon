class RatingsController < ApplicationController
  before_action :authenticate_customer!
  authorize_resource

  # POST /ratings
  # POST /ratings.json
  def create
    @book = Book.find(params[:book_id])
    @rating = @book.ratings.new(rating_params)
    @rating.customer_id = current_customer.id
    respond_to do |format|
      if current_customer.did_not_rate?(@book.id)
        if @rating.save
          format.html { redirect_to @book, notice: t(:rating_suc_create) }
          format.json { redirect_to @book, status: :created, location: @rating }
        else
          format.html { redirect_to @book, alert: t(:rating_fails_create) }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @book, alert: t(:rated_already) }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private 
    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :text)
    end
end

