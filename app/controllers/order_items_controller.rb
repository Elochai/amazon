class OrderItemsController < ApplicationController
  before_filter :authenticate_customer!
  load_and_authorize_resource
 
  # GET /order_items/1/edit
  def edit
  end
 
  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to new_order_path, notice: t(:quantity_suc_updated) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', alert: t(:quantity_fail_update) }
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

  def add_to_order
    if current_customer.order_items.in_cart_with(params[:book_id]).empty?
      current_customer.order_items.create(book_id: params[:book_id], quantity: params[:quantity])
    else
      current_customer.order_items.find_by(order_id: nil, book_id: params[:book_id]).increase_quantity!(params[:quantity])
    end
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
