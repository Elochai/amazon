class Delivery < ActiveRecord::Base
  has_many :orders
  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
end
