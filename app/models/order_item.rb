class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  belongs_to :customer

  validate :if_in_stock
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  before_save :count_price!
  scope :in_cart_with, ->(book) {where('order_id IS NULL AND book_id = ?', book)}
  scope :in_cart, -> {where('order_id IS NULL')}

  def count_price!
    self.price = (book.price * quantity).to_f
  end

  def increase_quantity!(number)
    self.quantity += number.to_f
    save
  end

  def decrease_quantity!
    self.quantity -= 1
    save
  end

  def add_to_order!(book, quantity, customer)
    if customer.order_items.in_cart_with(book).empty?
      self.update(book_id: book, quantity: quantity, customer_id: customer.id)
      self.save
    else
      OrderItem.find_by(order_id: nil, book_id: book, customer_id: customer.id).increase_quantity!(quantity)
    end
  end

  private 
  def if_in_stock
    unless book.in_stock.to_i >= quantity.to_i
      errors.add(:book, 'not in stock!')
    end
  end

end
