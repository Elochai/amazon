class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.float :price
      t.integer :quantity, default: 1
      t.integer :book_id
      t.integer :order_id
      t.index :book_id
      t.index :order_id

      t.timestamps
    end
  end
end
