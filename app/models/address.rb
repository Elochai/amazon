class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :order
  belongs_to :customer

  validates :phone, :zipcode, :address, :city, :country, presence: true
  validates :zipcode, format: {with: /\A[0-9]{5}\z/, message: "should contain 5 digits"}
end
