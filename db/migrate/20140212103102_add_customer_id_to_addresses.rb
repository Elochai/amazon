class AddCustomerIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :customer_id, :integer
    add_index :addresses, :customer_id
  end
end
