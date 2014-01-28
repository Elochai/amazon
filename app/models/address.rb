class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :order

  validates :phone, :zipcode, :address, :city, presence: true
end
