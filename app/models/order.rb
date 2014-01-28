class Order < ActiveRecord::Base
  belongs_to :customer
  has_one :credit_card
  has_one :bill_address, class_name: 'BillAddress' 
  has_one :ship_address, class_name: 'ShipAddress' 
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :credit_card, :allow_destroy => true#, :reject_if => proc {|attrs| attrs.all {|k,v| v.blank?}}
  accepts_nested_attributes_for :bill_address, :allow_destroy => true
  accepts_nested_attributes_for :ship_address, :allow_destroy => true

  validates :state, inclusion: { in: %w(in_progress shipped completed) }

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

