class CreditCard < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  belongs_to :customer

  validates :number, uniqueness: true, presence: true
  validates :cvv, :expiration_month, :expiration_year, :firstname, :lastname, presence: true
end
