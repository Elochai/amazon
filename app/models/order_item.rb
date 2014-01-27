class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validate :if_in_stock
  validates :price, :quantity, presence: true

  def price
    book.price * quantity
  end

  def decrease_in_stock!
    self.book.in_stock -= quantity
    save!
  end

  def return_in_stock!
    self.book.in_stock += quantity
    save!
  end

  def increase_quantity!
    self.quantity += 1
    save!
  end

  def decrease_quantity!
    self.quantity -= 1
    save!
  end

  private 
  def if_in_stock
    unless book.in_stock.to_i >= quantity.to_i
      errors.add(:book, 'not in stock!')
    end
  end

end
