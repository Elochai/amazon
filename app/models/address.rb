class Address < ActiveRecord::Base
  belongs_to :country

  validates :phone, :zipcode, :address, :city, presence: true
end
