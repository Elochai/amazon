class Book < ActiveRecord::Base
  mount_uploader :cover, CoverUploader
  paginates_per 6
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
  scope :top_rated, -> {where("avg_rating > 0").order("avg_rating DESC").limit(5)}
end
