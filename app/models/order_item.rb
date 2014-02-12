class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  belongs_to :customer

  validate :if_in_stock
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  before_save :count_price!

  def count_price!
    self.price = (book.price * quantity).to_f
  end

  def increase_quantity!
    self.quantity += 1
    save
  end

  def decrease_quantity!
    self.quantity -= 1
    save
  end

  private 
  def if_in_stock
    unless book.in_stock.to_i >= quantity.to_i
      errors.add(:book, 'not in stock!')
    end
  end

end
