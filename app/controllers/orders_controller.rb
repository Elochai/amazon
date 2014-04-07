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

  def checkout
    current_order.next_step!
    redirect_to new_address_path
  end

  def next_step
    if params[:step] == '2'
      redirect_to new_address_path
    elsif params[:step] == '3'
      redirect_to order_delivery_path
    elsif params[:step] == '4'
      redirect_to new_credit_card_path
    elsif params[:step] == '5'
      redirect_to order_confirm_path
    end
  end

  def update_with_coupon
    if current_order.checkout_step == 1
      if @coupon = Coupon.find_by(number: params[:coupon])
        current_order.update(coupon_id: @coupon.id)
        redirect_to order_items_path, notice: t(:succ_coupon) 
      else
        redirect_to order_items_path, alert: t(:fail_coupon)
      end
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
  end

  def remove_coupon
    if current_order.checkout_step == 1
      current_order.update(coupon_id: nil)
      redirect_to order_items_path, notice: t(:remove_coupon_notice)
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
  end

  def delivery
    if current_order.delivery.nil?
      if current_order.checkout_step == 3
        current_order.set_step! 3
      elsif current_order.checkout_step > 3
        redirect_to new_credit_card_path
      elsif current_order.checkout_step < 3
        redirect_to new_address_path
      end
    else
      @order = current_order
    end
  end

  def confirm
    if current_order.checkout_step == 5
      current_order.set_step! 5
    elsif current_order.checkout_step < 5
      redirect_to new_credit_card_path
    elsif current_order.order_items.empty?
      redirect_to root_path, alert: t(:select_books_to_buy)
    end
  end

  def add_delivery
    @order = current_order
    if current_order.delivery 
      has = true
    end
    if Delivery.where(id: params[:delivery_id]).any?
      @order.update(delivery_id: params[:delivery_id])
      if has == true
        current_order.set_step! current_order.checkout_step - 1
      end
      current_order.next_step!
      redirect_to step_path(current_order.checkout_step), notice: t(:delivery_suc_create)
    else
      redirect_to order_delivery_path, alert: t(:delivery_fail_create)
    end
  end

  def edit_delivery
    @order = current_order
  end

  def place
    if current_order.checkout_step == 5
      current_order.to_queue!(current_customer)
      id = current_order.id
      cookies.delete :current_order
      redirect_to order_path(id), notice: t(:order_suc_create)
    else 
      redirect_to order_items_path
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

