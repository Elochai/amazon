class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :ship_address, class_name: 'Address'
  belongs_to :bill_address, class_name: 'Address'
  has_many :order_items, dependent: :destroy
  accept_nested_attributes_for :credit_card, allow_destroy: true
  accept_nested_attributes_for :ship_address, allow_destroy: true
  accept_nested_attributes_for :bill_address, allow_destroy: true

  validates :state, inclusion: { in: %w(in_progress shipped completed) }

  #after_save :decrease_in_stock!
  #before_destroy :return_in_stock!

  def price
    order_items.map {|item| item.price}.sum.to_f
  end

  def decrease_in_stock!
    order_items.each do |item|
      book = Book.find(item.book_id)
      book.in_stock -= item.quantity
      book.save!
    end
  end

  def return_in_stock!
    order_items.each do |item|
      book = Book.find(item.book_id)
      book.in_stock += item.quantity
      book.save!
    end
  end

  def complete!
    self.completed_at = Date.today
    self.state = "completed"
    save!
  end

  def in_progress!
    self.state = "in_progress"
    save!
  end

  def shipped!
    self.state = "shipped"
    save!
  end
end

