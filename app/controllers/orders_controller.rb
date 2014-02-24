  class OrdersController < ApplicationController
  load_and_authorize_resource
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
    @credit_card = @order.build_credit_card
    @bill_address = @order.build_bill_address
    @ship_address = @order.build_ship_address
  end
 
  # POST /orders
  # POST /orders.json
  def create
    @order = current_customer.orders.new(order_params)
    respond_to do |format|
      if current_customer.has_anything_in_cart?
        if @order.save!
          @order.update_store!(current_customer)
          format.html { redirect_to @order, notice: t(:order_suc_create) }
          format.json { render action: 'show', status: :created, location: @order }
        else
          format.html { render action: 'new'}
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new', alert: t(:select_books_to_buy)}
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:price, :state, credit_card_attributes: [:id, :number, :cvv, :firstname, :lastname, :expiration_month, :expiration_year], bill_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id], ship_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id])
    end
end

