class AddCheckoutStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checkout_sate, :string
  end
end
