class CreditCard < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order

  validates :number, presence: true
  validates :cvv, :expiration_month, :expiration_year, :firstname, :lastname, presence: true
  validates :number, format: {with: /\A[0-9]{12,16}\z/, message: 'should contain 12-16 digits'}
  validates :cvv, format: {with: /\A[0-9]{3,4}\z/, message: 'should 3-4 digits'}
  validates :expiration_month, inclusion: { in: Time.now.month + 1..12 }
  validates :expiration_year, inclusion: { in: Time.now.year..Time.now.year + 15}, unless: :december?
  validates :expiration_year, inclusion: { in: Time.now.year + 1..Time.now.year + 15}, if: :december?

  def december?
    if Time.now.month < 12
      false
    else
      true
    end
  end
end
