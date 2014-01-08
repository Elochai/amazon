class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.float :price
      t.integer :in_stock
      t.integer :author_id
      t.integer :category_id

      t.timestamps
    end
  end
end
