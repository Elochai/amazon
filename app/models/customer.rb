class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders, dependent: :destroy
  has_one :credit_card, dependent: :destroy
  has_one :bill_address, class_name: 'BillAddress', dependent: :destroy
  has_one :ship_address, class_name: 'ShipAddress', dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
  
  validates :email, format: { with: /\A.+@.+\z/ }, uniqueness: true, presence: true

  def order_price
    order_items.where(order_id: nil).map {|item| item.price}.sum.to_f
  end
end
