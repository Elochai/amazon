class SessionsController < Devise::SessionsController

  before_filter :delete_inactive_orders, :only => :destroy

  def delete_inactive_orders
      current_customer.order_items.where(order_id: nil).destroy_all
  end
end