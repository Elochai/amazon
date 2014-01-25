class Book < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def add_in_stock!
    self.in_stock += 1
    save!
  end

  def author
    Author.find(self.author_id).firstname.to_s + " " + Author.find(self.author_id).lastname.to_s
  end

  def category
    Category.find(self.category_id).title
  end
end
