class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book
  validates :rating, inclusion: { in: 1..10 }, presence: true

  after_save :avg_rating

  def already_rated?
    Rating.where(customer_id: customer.id, book_id: book.id).empty?
  end

  def avg_rating
    sum = 0
    @book = Book.find(self.book_id)
    @book.ratings.where(approved: true).each do |item|
      unless item.rating.nil?
        sum += item.rating
      end
    end
    if @book.ratings.where(approved: true).count > 0
      @book.avg_rating = sum/@book.ratings.where(approved: true).count
      @book.save!
    else
      @book.avg_rating = 0
      @book.save!     
    end
  end
end
