class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :delivery
  belongs_to :coupon
  has_one :credit_card, dependent: :destroy
  has_one :bill_address, class_name: 'BillAddress', dependent: :destroy
  has_one :ship_address, class_name: 'ShipAddress', dependent: :destroy
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :bill_address
  accepts_nested_attributes_for :ship_address

  validates :state, inclusion: { in: %w(in_progress in_queue in_delivery delivered) }
  validates :checkout_step, inclusion: { in: 1..5 }
  validates :state, :price, presence: true

  state_machine :state, :initial => :in_progress do
    after_transition :on => :complete, :do => :complete!

    event :checkout do
      transition :in_progress => :in_queue
    end

    event :proceed do
      transition :in_queue => :in_delivery
    end

    event :complete do
      transition :in_delivery => :delivered
    end
  end

  rails_admin do
    list do
      filters [:state]
      field :id
      field :state, :state
      field :customer 
      field :price
      field :order_items 
      field :delivery
      field :coupon
      field :completed_at
      include_all_fields
    end
    edit do
      include_all_fields
      field :state, :state
    end
  end

  def total_price
    sum = order_items.map {|item| item.price}.sum
    if coupon_id
      sum = (sum - (sum * coupon.discount)).to_f
    end
    if delivery_id
      sum = sum + delivery.price
    end
    sum
  end

  def books_price
    sum = order_items.map {|item| item.price}.sum
    if coupon_id
      sum = (sum - (sum * coupon.discount)).to_f
    end
    sum
  end

  def to_queue!(customer)
    self.order_items.each do |item|
      book = Book.find(item.book_id)
      book.in_stock -= item.quantity
      book.save
    end
    self.update(customer_id: customer.id, state: 'in_queue', price: self.total_price)
  end

  def complete!
    self.completed_at = Date.today
    save
  end

  def next_step!
    self.checkout_step += 1
    save
  end

  def set_step!(value)
    self.checkout_step = value
    self.save
  end

  def self.delete_abandoned!
    Order.where(state: 'in_progress').each do |order|
      if order.updated_at < 5.hours.ago
        order.destroy
      end
    end
  end
end

