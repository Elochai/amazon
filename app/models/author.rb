class Author < ActiveRecord::Base
  has_many :books

  validates :firstname, :lastname, presence: true

  def full_name
    firstname + " " + lastname
  end
end
