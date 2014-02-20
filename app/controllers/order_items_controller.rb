class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy, :increase, :decrease, :set_quantity]
  before_filter :authenticate_customer!
  authorize_resource
 
  # GET /order_items/1/edit
  def edit
  end
 
  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to new_order_path, notice: 'Quantity was successfully changed.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', alert: "Sorry, we don't have so many in stock." }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to new_order_path }
      format.json { head :no_content }
    end
  end

  def clear_cart
    current_customer.order_items.destroy_all
    redirect_to new_order_path
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:price, :quantity, :order_id, :book_id)
    end
end
