class Category < ActiveRecord::Base
  has_many :books

  validates :title, uniqueness: true, presence: true

  def number_of_books
    Book.where(category_id: self.id).count
  end
end
