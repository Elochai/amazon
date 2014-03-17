class CustomerBillAddressesController < ApplicationController
  load_and_authorize_resource
 
  # GET /addresses/new
  def new
    if current_customer.customer_bill_address.nil?
      @customer_bill_address = current_customer.build_customer_bill_address
    else
      redirect_to edit_customer_registration_path, alert: t(:already_have_bill_address)
    end
  end
 
  # GET /addresses/1/edit
  def edit
    if @customer_bill_address.customer_id == current_customer.id
      @customer_bill_address
    else
      redirect_to root_path
    end
  end
 
  # POST /addresses
  # POST /addresses.json
  def create
    @customer_bill_address = current_customer.build_customer_bill_address(customer_bill_address_params)
    respond_to do |format|
      if @customer_bill_address.save
        format.html { redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_create) }
        format.json { redirect_to edit_customer_registration_path, status: :created, location: @customer_bill_address}
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_bill_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @customer_bill_address.update(customer_bill_address_params)
        format.html { redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_update) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_bill_address.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @customer_bill_address.customer_id == current_customer.id
      @customer_bill_address.destroy
      redirect_to edit_customer_registration_path, notice: t(:bill_address_suc_delete)
    else
      redirect_to root_path
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @customer_bill_address = CustomerBillAddress.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_bill_address_params
      params.require(:customer_bill_address).permit(:address, :zipcode, :city, :phone, :country_id)
    end
end
