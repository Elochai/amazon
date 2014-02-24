class CategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end
 
  # GET /categories/1
  # GET /categories/1.json
  def show
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end
end
