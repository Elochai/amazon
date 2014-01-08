class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address
      t.integer :zipcode
      t.string :city
      t.string :phone
      t.integer :country_id

      t.timestamps
    end
  end
end
