class RemoveForCustomerFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :for_customer, :boolean
  end
end
