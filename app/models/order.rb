class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :ship_address, class_name: 'Address'
  belongs_to :bill_address, class_name: 'Address'
  has_many :order_items, dependent: :destroy

  validates :state, inclusion: { in: %w(inactive in_progress shipped completed) }

  before_save :refresh_on_save
  before_destroy :refresh_on_destroy

  def price
    order_items.map {|item| item.price}.sum
  end

  def refresh_on_save
    unless state = 'inactive'
      order_items.each do |item|
        item.decrease_in_stock!
      end
    end
  end

  def refresh_on_destroy
    order_items.each do |item|
      item.return_in_stock!
    end
  end

  def inactive!
    self.state = "inactive"
    save!
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

