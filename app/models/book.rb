class Book < ActiveRecord::Base
  mount_uploader :cover, CoverUploader
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category
  has_and_belongs_to_many :wishers, class_name: 'Customer'

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :description, length: { maximum: 350 }

  scope :by_author, ->(author) {where('author_id = ?', author)}
  scope :by_category, ->(category) {where('category_id = ?', category)}

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
