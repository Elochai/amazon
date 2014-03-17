class AddProviderAndUrlToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :url, :string
    add_column :customers, :provider, :string
  end
end
