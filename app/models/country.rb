class Country < ActiveRecord::Base
  validates :name, uniqueness: true
end
