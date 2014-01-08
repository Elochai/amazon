class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :address
  has_many :order_items, dependent: :destroy

  validates :state, format: { with: /\Ain progress\z|\Acompleted\z|\Ashipped\z/ }

  after_find :total_price
  after_create :set_initial_state

  def total_price
    self.total_price = self.order_items.sum("price")
  end

  def complete_order
    self.completed_at = Date.today
  end

  def set_initial_state
    self.state = "in progress"
  end

end

