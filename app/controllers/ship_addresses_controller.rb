class ShipAddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_customer!
  authorize_resource
 
  # GET /addresses/new
  def new
    if current_customer.ship_address.nil?
      @ship_address = current_customer.build_ship_address
    else
      redirect_to edit_customer_registration_path, alert: 'You already have ship address. Edit it if you want.'
    end
  end
 
  # GET /addresses/1/edit
  def edit
  end
 
  # POST /addresses
  # POST /addresses.json
  def create
    @ship_address = current_customer.build_ship_address(ship_address_params)
 
    respond_to do |format|
      if @ship_address.save
        format.html { redirect_to edit_customer_registration_path, notice: 'Ship address was successfully created.' }
        format.json { redirect_to edit_customer_registration_path, status: :created, location: @ship_address }
      else
        format.html { render action: 'new' }
        format.json { render json: @ship_address.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @ship_address.update(ship_address_params)
        format.html { redirect_to edit_customer_registration_path, notice: 'Ship address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ship_address.errors , status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @ship_address.destroy
    respond_to do |format|
      format.html { redirect_to edit_customer_registration_path, notice: 'Ship address was successfully deleted.' }
      format.json { head :no_content }
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
