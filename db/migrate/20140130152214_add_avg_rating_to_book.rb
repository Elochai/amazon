class AddAvgRatingToBook < ActiveRecord::Migration
  def change
    add_column :books, :avg_rating, :integer
  end
end
