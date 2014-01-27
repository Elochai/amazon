class SessionsController < Devise::SessionsController

  before_filter :delete_inactive_orders, :only => :destroy
  after_filter :create_new_order, :only => :create

  def delete_inactive_orders
      current_customer.orders.where(state: 'inactive').destroy_all
  end

  def create_new_order
    if customer_signed_in?
      current_customer.orders.create(state: 'inactive')
    end
  end
end