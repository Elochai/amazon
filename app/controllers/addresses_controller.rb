class AddressesController < ApplicationController
  before_filter :if_no_current_order?
  load_and_authorize_resource
 
  # GET /addresses/new
  def new
    if current_order.bill_address.nil?
      if current_order.checkout_step >= 2
        current_order.set_step! 2
        @order = current_order
        @bill_address = @order.build_bill_address
        @ship_address = @order.build_ship_address
      else
        redirect_to order_items_path
      end
    else
      @order = current_order
    end
  end
 
  # POST /addresses
  # POST /addresses.json
  def create
    @order = current_order
    if current_order.bill_address 
      has = true
    end
    if params[:use_ba] == 'yes'
      if @order.update_attributes(bill_address_attributes: bill_address_params, ship_address_attributes: bill_address_params) 
        if has == true
          current_order.set_step! current_order.checkout_step - 1
        end
        current_order.next_step!
        redirect_to step_path(current_order.checkout_step), notice: t(:address_suc_create) 
      else
        render action: 'new'
      end
    else 
      if @order.update_attributes(address_params)
        if has == true
          current_order.set_step! current_order.checkout_step - 1
        end
        current_order.next_step!
        redirect_to step_path(current_order.checkout_step), notice: t(:address_suc_create) 
      else
        render action: 'new'
      end
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_address_params
      params.require(:order).require(:bill_address_attributes).permit(:country_id, :address, :zipcode, :city, :phone)
    end

    def address_params
      params.require(:order).permit(bill_address_attributes: [:id, :country_id, :address, :zipcode, :city, :phone], ship_address_attributes: [:id, :country_id, :address, :zipcode, :city, :phone])
    end
end
