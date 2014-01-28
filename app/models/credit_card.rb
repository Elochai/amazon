class CreditCard < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order

  validates :number, uniqueness: true, presence: true
  validates :cvv, :expiration_month, :expiration_year, :firstname, :lastname, presence: true
  validates :number, format: {with: /\A[0-9]{12,16}\z/, message: 'should contain 12-16 digits'}
  validates :cvv, format: {with: /\A[0-9]{3,4}\z/, message: 'should 3-4 digits'}
end
