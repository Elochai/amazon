class ShipAddressesController < ApplicationController
  before_filter :if_no_current_order?
  load_and_authorize_resource
 
  # GET /addresses/1/edit
  def edit
    if @ship_address.order_id == current_order.id
      @ship_address
    else
      redirect_to root_path
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    if params[:use_ba]
      attrs = {address: current_order.bill_address.address, city: current_order.bill_address.city, phone: current_order.bill_address.phone, zipcode: current_order.bill_address.zipcode, country_id: current_order.bill_address.country.id}
    else
      attrs = ship_address_params
    end
    respond_to do |format|
      if @ship_address.update_attributes(attrs)
        format.html { redirect_to order_confirm_path, notice: t(:ship_address_suc_update) }
        format.json { head :no_content }
      else
        format.html { render "edit" }
        format.json { render json: @ship_address.errors , status: :unprocessable_entity }
      end
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @ship_address = ShipAddress.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def ship_address_params
      params.require(:ship_address).permit(:address, :zipcode, :city, :phone, :country_id)
    end
end
