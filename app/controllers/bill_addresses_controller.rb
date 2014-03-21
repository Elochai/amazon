class BillAddressesController < ApplicationController
  before_filter :if_no_current_order?
  load_and_authorize_resource
 
  # GET /addresses/1/edit
  def edit
    if @bill_address.order_id == current_order.id
      @bill_address
    else
      redirect_to root_path
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @bill_address.update(bill_address_params)
        format.html { redirect_to order_confirm_path, notice: t(:bill_address_suc_update) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bill_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @bill_address = BillAddress.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_address_params
      params.require(:bill_address).permit(:address, :zipcode, :city, :phone, :country_id)
    end
end
