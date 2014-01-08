class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.text :biography
      t.string :photo

      t.timestamps
    end
  end
end
