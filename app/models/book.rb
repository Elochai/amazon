class Book < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }
end
