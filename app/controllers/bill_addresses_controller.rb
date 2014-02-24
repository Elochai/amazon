class BillAddressesController < ApplicationController
  before_filter :authenticate_customer!
  load_and_authorize_resource
 
  # GET /addresses/new
  def new
    if current_customer.bill_address.nil?
      @bill_address = current_customer.build_bill_address
    else
      redirect_to edit_customer_registration_path, alert: t(:already_have_bill_address)
    end
  end
 
  # GET /addresses/1/edit
  def edit
  end
 
  # POST /addresses
  # POST /addresses.json
  def create
    @bill_address = current_customer.build_bill_address(bill_address_params)
 
    respond_to do |format|
      if @bill_address.save
        format.html { redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_create) }
        format.json { redirect_to edit_customer_registration_path, status: :created, location: @bill_address}
      else
        format.html { render action: 'new' }
        format.json { render json: @bill_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @bill_address.update(bill_address_params)
        format.html { redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_update) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bill_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @bill_address.destroy
    respond_to do |format|
      format.html { redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_delete) }
      format.json { head :no_content }
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
