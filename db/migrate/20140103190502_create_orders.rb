class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :price
      t.string :state
      t.date :completed_at
      t.integer :bill_address_id
      t.integer :ship_address_id
      t.integer :customer_id
      t.integer :credit_card_id
      t.index :credit_card_id
      t.index :bill_address_id
      t.index :ship_address_id
      t.index :customer_id

      t.timestamps
    end
  end
end
