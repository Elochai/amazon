class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy, :increase, :decrease, :set_quantity]
  before_filter :authenticate_customer!
  load_and_authorize_resource
  # GET /order_items
  # GET /order_items.json
  def index
    @order_items = OrderItem.all
  end
 
  # GET /order_items/1
  # GET /order_items/1.json
  def show
  end
 
  # GET /order_items/new
  def new
    @order_item = OrderItem.new
  end
 
  # GET /order_items/1/edit
  def edit
  end
 
  # POST /order_items
  # POST /order_items.json
  def create
    @order_item = OrderItem.new(order_item_params)
 
    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
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
        format.html { redirect_to new_order_path, notice: 'Quantity was successfully changed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: "Sorry, we don't have so many in stock." }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def clear_cart
    current_customer.order_items.destroy_all
    redirect_to :back
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:price, :quantity, :order_id, :book_id)
    end
end
