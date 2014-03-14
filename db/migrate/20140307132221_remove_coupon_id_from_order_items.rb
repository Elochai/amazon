class RemoveCouponIdFromOrderItems < ActiveRecord::Migration
  def change
    remove_column :order_items, :coupon_id, :integer
  end
end
