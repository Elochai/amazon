class AddCheckoutStepToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checkout_step, :integer, default: 1
  end
end
