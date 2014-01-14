class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validate :if_in_stock
  validates :price, :quantity, presence: true

  before_save :count_total_price

  def total_price
    book.price * quantity
  end

  def count_total_price
    self.price = book.price * quantity
  end

  def decrease_in_stock!
    self.book.in_stock -= quantity
    save!
  end

  def return_in_stock!
    self.book.in_stock += quantity
    save!
  end

  private 
  def if_in_stock
    unless book.in_stock.to_i >= quantity.to_i
      errors.add(:book, 'not in stock!')
    end
  end

end
