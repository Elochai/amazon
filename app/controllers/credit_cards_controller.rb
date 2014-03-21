class CreditCardsController < ApplicationController
  before_filter :if_no_current_order?
  load_and_authorize_resource
 
  # GET /credit_cards/new
  def new
    if current_order.credit_card.nil?
      if current_order.checkout_step == 4
        current_order.set_step! 4
        @credit_card = current_order.build_credit_card
      elsif current_order.checkout_step < 4
        redirect_to order_delivery_path
      elsif current_order.checkout_step > 4
        redirect_to order_confirm_path
      end
    else
      @credit_card = current_order.credit_card
    end
  end
 
  # GET /credit_cards/1/edit
  def edit
    if @credit_card.order_id == current_order.id
      @credit_card
    else
      redirect_to root_path
    end
  end
 
  # POST /credit_cards
  # POST /credit_cards.json
  def create
    @credit_card = current_order.build_credit_card(credit_card_params)
    if current_order.credit_card 
      has = true
    end
    respond_to do |format|
      if @credit_card.save
        if has == true
          current_order.set_step! current_order.checkout_step - 1
        end
        current_order.next_step!
        format.html { redirect_to step_path(current_order.checkout_step), notice: t(:cc_suc_create) }
        format.json { redirect_to step_path(current_order.checkout_step), status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /credit_cards/1
  # PATCH/PUT /credit_cards/1.json
  def update
    respond_to do |format|
      if @credit_card.update(credit_card_params)
        format.html { redirect_to order_confirm_path, notice: t(:cc_suc_update) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_card_params
      params.require(:credit_card).permit(:number, :cvv, :expiration_month, :expiration_year, :firstname, :lastname, :customer_id)
    end
end

