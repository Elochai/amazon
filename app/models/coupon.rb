class Coupon < ActiveRecord::Base
  has_many :orders

  validates :number, :discount, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0.01 }
end
