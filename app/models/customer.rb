class Customer < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  
  validates :email, format: { with: /\A.+@.+\z/ }, uniqueness: true, presence: true
  validates :password, length: { in: 6..20 }, presence: true
  validates :firstname, :lastname, presence: true
end
