class CreditCard < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  belongs_to :customer

  validates :number, uniqueness: true
end
