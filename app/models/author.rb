class Author < ActiveRecord::Base
  has_many :books

  validates :firstname, :lastname, presence: true
end
