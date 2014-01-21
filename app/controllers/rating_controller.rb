class RatingController < ApplicationController
            before_action :set_rating, only: [:show, :edit, :update, :destroy]
 
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.all
  end
 
  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end
 
  # GET /ratings/new
  def new
    @rating = Rating.new
  end
 
  # GET /ratings/1/edit
  def edit
  end
 
  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new(rating_params)
 
    respond_to do |format|
      if @post.save
        format.html { redirect_to @rating, notice: 'rating was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rating }
      else
        format.html { render action: 'new' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @post, notice: 'rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ratings
      @rating = rating.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :text, :customer_id, :book_id)
    end
end
end
end
