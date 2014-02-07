class Book < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }, presence: true

  scope :by_author, ->(author) {where('author_id = ?', author)}
  scope :by_category, ->(category) {where('category_id = ?', category)}

  def add_in_stock!
    self.in_stock += 1
    save!
  end

  def avg_rating
    sum = 0
    ratings.where(approved: true).each do |item|
      unless item.rating.nil?
        sum += item.rating
      end
    end
    if ratings.where(approved: true).count > 0
      sum/ratings.where(approved: true).count
    else
      0
    end
  end
end
