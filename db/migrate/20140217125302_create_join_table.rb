class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :books, :customers do |t|
      t.index [:book_id, :customer_id]
      t.index [:customer_id, :book_id]
    end
  end
end
