class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.float :price
      t.integer :in_stock, default: 0
      t.integer :author_id
      t.integer :category_id
      t.index :author_id
      t.index :category_id

      t.timestamps
    end
  end
end
