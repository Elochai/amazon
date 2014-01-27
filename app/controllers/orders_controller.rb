class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
 
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end
 
  # GET /orders/1
  # GET /orders/1.json
  def show
  end
 
  # GET /orders/new
  def new
    @order = Order.new
  end
 
  # GET /orders/1/edit
  def edit
  end
 
  # POST /orders
  # POST /orders.json
  def create
    @order = current_customer.orders.create(state: 'inactive')

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { redirect_to :root }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:price, :state, :completed_at, :bill_address_id, :ship_address_id, :customer_id, :credit_card_id)
    end
end

