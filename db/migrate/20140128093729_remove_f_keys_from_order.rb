class RemoveFKeysFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :credit_card_id, :string
    remove_column :orders, :bill_address_id, :string
    remove_column :orders, :ship_address_id, :string
  end
end
