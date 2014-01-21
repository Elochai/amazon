class order_itemItemController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
 
  # GET /order_items
  # GET /order_items.json
  def index
    @order_items = Order_item.all
  end
 
  # GET /order_items/1
  # GET /order_items/1.json
  def show
  end
 
  # GET /order_items/new
  def new
    @order_item = Order_item.new
  end
 
  # GET /order_items/1/edit
  def edit
  end
 
  # POST /order_items
  # POST /order_items.json
  def create
    @order_item = Order_item.new(order_item_params)
 
    respond_to do |format|
      if @post.save
        format.html { redirect_to @order_item, notice: 'order_item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to @post, notice: 'order_item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_items_url }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_items
      @order_item = order_item.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:price, :quantity, :order_id, :book_id)
    end
end
end
end
