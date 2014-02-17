class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book
  validates :rating, inclusion: { in: 1..10 }, presence: true

  def approve!
    self.approved = true
    save!
  end

  def already_rated?
    Rating.where(customer_id: customer.id, book_id: book.id).empty?
  end
end
