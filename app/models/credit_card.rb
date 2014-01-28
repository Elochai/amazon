class CreditCard < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order

  validates :number, uniqueness: true, presence: true
  validates :cvv, :expiration_month, :expiration_year, :firstname, :lastname, presence: true
end
