class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book
  validates :rating, inclusion: { in: 1..10 }, presence: true

end
