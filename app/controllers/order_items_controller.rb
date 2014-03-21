class OrderItemsController < ApplicationController
  load_and_authorize_resource
  before_filter :if_no_current_order?, except: :create

  def index 
    if current_order.checkout_step == 1
      @order_items = current_order.order_items
    elsif current_order.checkout_step > 1
      redirect_to order_confirm_path
    end
  end
 
  # GET /order_items/1/edit
  def edit
    if current_order.checkout_step == 1
      if @order_item.order_id == current_order.id
        @order_item
      else
        redirect_to root_path
      end
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
  end
 
  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to order_items_path, notice: t(:quantity_suc_updated) }
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
    if current_order.checkout_step == 1
      if @order_item.order_id == current_order.id
        @order_item.destroy
        respond_to do |format|
          format.html { redirect_to order_items_path }
          format.json { head :no_content }
        end
      else
        redirect_to root_path
      end
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
  end

  def clear_cart
    if current_order.checkout_step == 1
      current_order.order_items.destroy_all
      redirect_to order_items_path
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
  end

  def create
    if cookies[:current_order]
      if Order.where(id: cookies[:current_order]).empty?
        cookies[:current_order] = Order.create(state: 'in_progress', price: 0.01).id
      end
    else
      cookies[:current_order] ||= Order.create(state: 'in_progress', price: 0.01).id
      @order_item = OrderItem.new
    end
    if current_order.checkout_step == 1
      respond_to do |format|
        if @order_item.add_to_order!(params[:book_id], params[:quantity], cookies[:current_order])
          format.html { redirect_to order_items_path, notice: t(:oi_succ_create) }
          format.json { head :no_content }
        else
          format.html { redirect_to root_path, alert: t(:oi_fail_create) }
          format.json { render json: @order_item.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to order_confirm_path, alert: t(:already_checked_out)
    end
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
