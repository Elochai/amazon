class CheckInStock < ActiveModel::Validator
  def validate(record)
    unless record.book.in_stock > 0
      record.errors[:in_stock] << "no book in stock"
    end
  end
end

class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates_with CheckInStock
  validates :price, :quantity, presence: true

  before_save :count_total_price!

  def count_total_price!
    self.price = self.book.price * self.quantity
  end

end
