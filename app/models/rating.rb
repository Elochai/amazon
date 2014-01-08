class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book
  validates :rating, numericality: { greater_than: 0, less_than: 11 }
end
