  class OrdersController < ApplicationController
  before_filter :if_no_current_order?, except: [:show, :index]
  load_and_authorize_resource
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_customer.orders
  end
 
  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  def update_with_coupon
    if @coupon = Coupon.find_by(number: params[:coupon])
      current_order.update(coupon_id: @coupon.id)
      redirect_to order_items_path, notice: t(:succ_coupon) 
    else
      redirect_to order_items_path, alert: t(:fail_coupon)
    end
  end

  def remove_coupon
    current_order.update(coupon_id: nil)
    redirect_to order_items_path, notice: t(:remove_coupon_notice)
  end

  def delivery
    if current_order.checkout_step > 3
      redirect_to new_credit_card_path
    elsif current_order.checkout_step < 3
      redirect_to new_ship_address_path
    end
  end

  def confirm
    if current_order.checkout_step < 5
      redirect_to new_credit_card_address_path
    elsif current_order.order_items.empty?
      redirect_to root_path, alert: t(:select_books_to_buy)
    end
  end

  def add_delivery
    if Delivery.where(id: params[:delivery_id]).any?
      current_order.update(delivery_id: params[:delivery_id])
      current_order.next_step!
      redirect_to new_credit_card_path, notice: t(:delivery_suc_create)
    else
      redirect_to order_delivery_path, alert: t(:delivery_fail_create)
    end
  end

  def edit_delivery
  end

  def place
    current_order.to_queue!(current_customer)
    cookies.delete :current_order
    redirect_to root_path, notice: t(:order_suc_create)
  end

  def destroy
    current_order.destroy
    cookies.delete :current_order
    redirect_to root_path, notice: t(:order_suc_delete)
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

