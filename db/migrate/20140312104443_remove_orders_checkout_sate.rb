class RemoveOrdersCheckoutSate < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.remove :checkout_sate
    end
  end
end
