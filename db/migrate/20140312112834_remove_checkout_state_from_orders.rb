class RemoveCheckoutStateFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :checkout_state, :string
  end
end
