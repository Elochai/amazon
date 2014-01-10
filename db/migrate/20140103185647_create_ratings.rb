class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.text :text
      t.integer :customer_id
      t.integer :book_id
      t.index :customer_id
      t.index :book_id

      t.timestamps
    end
  end
end
