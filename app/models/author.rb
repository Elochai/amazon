class Author < ActiveRecord::Base
  has_many :books

  validates :firstname, :lastname, presence: true

  def full_name
    firstname + " " + lastname
  end

  def number_of_books
    Book.where(author_id: self.id).count
  end

  def categories
    categories = []
    Book.where(author_id: self.id).each do |book|
      categories << book.category
    end
    categories.uniq
  end
end
