class Customer < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  validates :email, format: { with: /^.+@.+$/ }, uniqueness: true
  validates :password, confirmation: true, length: { in 6..20 }
  validates :password_confirmation, confirmation: true
end
