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
    order_items.in_cart.map {|item| item.price}.sum.to_f
  end

  def has_anything_in_cart?
    order_items.in_cart.any?
  end

  def did_not_rate?(book_id)
    ratings.where(book_id: book_id).empty?
  end
end
