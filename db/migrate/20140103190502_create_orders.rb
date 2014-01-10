class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :total_price
      t.string :state, default: "in progress"
      t.date :completed_at
      t.integer :bill_address_id
      t.integer :ship_address_id
      t.integer :customer_id
      t.index :bill_address_id
      t.index :ship_address_id
      t.index :customer_id

      t.timestamps
    end
  end
end
