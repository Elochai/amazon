class Book < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def add_in_stock!
    in_stock += 1
    save!
  end
end
