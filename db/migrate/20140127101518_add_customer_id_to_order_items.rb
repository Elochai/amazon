class AddCustomerIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :customer_id, :integer
    add_index :order_items, :customer_id
  end
end
