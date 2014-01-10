class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :number_of_books

      t.timestamps
    end
  end
end
