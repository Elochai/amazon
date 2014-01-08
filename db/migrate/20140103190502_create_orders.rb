class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :total_price
      t.string :state, default: "in progress"
      t.string :completed_at
      t.date :date
      t.string :bill_address
      t.string :text
      t.string :ship_address
      t.integer :customer_id
      t.integer :address_id

      t.timestamps
    end
  end
end
