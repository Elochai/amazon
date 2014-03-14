class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :number
      t.float :discount

      t.timestamps
    end
  end
end
