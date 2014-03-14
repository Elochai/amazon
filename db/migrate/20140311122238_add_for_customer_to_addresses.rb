class AddForCustomerToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :for_customer, :boolean, default: false
  end
end
