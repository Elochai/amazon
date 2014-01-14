class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :ship_address, class_name: 'Address'
  belongs_to :bill_address, class_name: 'Address'
  has_many :order_items, dependent: :destroy

  validates :state, inclusion: { in: %w(in_progress shipped completed) }, presence: true
  validates :price, presence: true

  before_save :count_total_price, :refresh_on_save, :in_progress!
  before_destroy :refresh_on_destroy

  def total_price
    order_items.sum("price")
  end

  def count_total_price
    price = order_items.sum("price")
  end

  def refresh_on_save
    order_items.each do |item|
      item.decrease_in_stock!
    end
  end

  def refresh_on_destroy
    order_items.each do |item|
      item.return_in_stock!
    end
  end

  def complete!
    completed_at = Date.today
    state = "completed"
    save!
  end

  def in_progress!
    state = "in_progress"
    save!
  end

  def shipped!
    state = "shipped"
    save!
  end
end

