  class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :shipped, :complete]
  before_filter :authenticate_customer!, only: [:index, :show, :new, :update]
  authorize_resource
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_customer.orders.load
  end
 
  # GET /orders/1
  # GET /orders/1.json
  def show
  end
 
  # GET /orders/new
  def new
    @order = current_customer.orders.new
    @order.build_credit_card
    @order.build_bill_address
    @order.build_ship_address
  end
 
  # POST /orders
  # POST /orders.json
  def create
    @order = current_customer.orders.new(order_params)
    @order.state = 'in_progress'
    @order.price = current_customer.order_price
    respond_to do |format|
      if current_customer.has_anything_in_cart?
        if @order.save!
          @order.update_store!(current_customer)
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render action: 'show', status: :created, location: @order }
        else
          format.html { render action: 'new'}
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new', alert: 'Please, select some book(s) to buy first'}
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def shipped
    if current_customer.admin == true
      @order.shipped!
      redirect_to :back
    end
  end

  def complete
    if current_customer.admin == true
      @order.complete!
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(credit_card_attributes: [:id, :number, :cvv, :firstname, :lastname, :expiration_month, :expiration_year], bill_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id], ship_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id])
    end
end

