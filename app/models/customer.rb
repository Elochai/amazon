class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :order_items, dependent: :destroy
  
  validates :email, format: { with: /\A.+@.+\z/ }, uniqueness: true, presence: true
  validates :password, presence: true

  def order_price
    order_items.where(order_id: nil).map {|item| item.price}.sum.to_f
  end
end
