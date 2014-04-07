class CustomerShipAddressesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_customer!
  # GET /addresses/new
  def new
    if current_customer.customer_ship_address.nil?
      @customer_ship_address = current_customer.build_customer_ship_address
    else
      redirect_to edit_customer_registration_path, alert: t(:already_have_ship_address)
    end
  end
 
  # GET /addresses/1/edit
  def edit
  end
 
  # POST /addresses
  # POST /addresses.json
  def create
    @customer_ship_address = current_customer.build_customer_ship_address(customer_ship_address_params)
    respond_to do |format|
      if @customer_ship_address.save
        format.html { redirect_to edit_customer_registration_path, notice: t(:ship_address_suc_create) }
        format.json { redirect_to edit_customer_registration_path, status: :created, location: @customer_ship_address}
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_ship_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @customer_ship_address.update(customer_ship_address_params)
        format.html { redirect_to edit_customer_registration_path, notice: t(:ship_address_suc_update) }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @customer_ship_address.errors , status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @customer_ship_address.customer_id == current_customer.id
      @customer_ship_address.destroy
      redirect_to edit_customer_registration_path, notice: t(:ship_address_suc_delete)
    else
      redirect_to root_path
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @customer_ship_address = CustomerShipAddress.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_ship_address_params
      params.require(:customer_ship_address).permit(:address, :zipcode, :city, :phone, :country_id)
    end
end
