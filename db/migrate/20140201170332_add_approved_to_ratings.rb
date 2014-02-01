class AddApprovedToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :approved, :boolean, default: false
  end
end
