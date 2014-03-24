class Book < ActiveRecord::Base
  filterrific(
    :default_settings => { :sorted_by => 'created_at_desc' },
    :filter_names => [
      :search_query,
      :sorted_by,
      :with_category_id,
      :with_author_id
    ]
  )
  mount_uploader :cover, CoverUploader
  paginates_per 6
  has_many :ratings, dependent: :destroy
  belongs_to :author
  belongs_to :category
  has_and_belongs_to_many :wishers, class_name: 'Customer'

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
  validates :in_stock, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :description, length: { maximum: 400 }

  scope :with_category_id, lambda { |category_ids| where(:category_id => [*category_ids]) }
  scope :with_author_id, lambda { |author_ids| where(:author_id => [*author_ids]) }
  scope :top_rated, -> {where("avg_rating > 0").order("avg_rating DESC").limit(5)}
  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("books.created_at #{ direction }")
    when /^title/
      order("LOWER(books.title) #{ direction }, LOWER(books.title) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :search_query, lambda { |query|
    where("LOWER(title) LIKE ?", "%#{query.downcase}%")
  }

  def self.options_for_sorted_by
    [
      [I18n.t(:title_asc), 'title_asc'],
      [I18n.t(:title_desc), 'title_desc'],
      [I18n.t(:date_desc), 'created_at_desc'],
      [I18n.t(:date_asc), 'created_at_asc']
    ]
  end

  def recalculate_avg_rating!
    if ratings.where(approved: true).any?
      self.avg_rating = self.ratings.where(approved: true).sum(:rating)/ratings.where(approved: true).count
      self.save
    else
      self.avg_rating = 0
      self.save
    end
  end
end
