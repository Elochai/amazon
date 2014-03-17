class AddCorrectCheckoutStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checkout_state, :string
  end
end
