class AddAdminToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :admin, :boolean
  end
end
