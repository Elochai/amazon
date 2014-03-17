class AddCouponIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :coupon_id, :integer
  end
end
