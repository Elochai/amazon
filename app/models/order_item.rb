class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  belongs_to :customer
  
  validate :if_in_stock
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  before_save :count_price!
  scope :in_cart_with, ->(book) {where('book_id = ?', book)}

  def count_price!
    self.price = (book.price * quantity).to_f
  end

  def increase_quantity!(number)
    self.quantity += number.to_i
    save
  end

  def add_to_order!(book, quantity, order)
    if Order.find(order.to_i).order_items.in_cart_with(book).empty?
      self.update(book_id: book, quantity: quantity, order_id: order.to_i)
    else
      OrderItem.find_by(order_id: order.to_i, book_id: book).increase_quantity!(quantity)
    end
  end

  private 
  def if_in_stock
    unless book.in_stock.to_i >= quantity.to_i
      errors.add(:book, 'not in stock!')
    end
  end

end
