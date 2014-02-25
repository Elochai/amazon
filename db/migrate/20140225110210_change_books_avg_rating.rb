class ChangeBooksAvgRating < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.change :avg_rating, :integer, default: 0
    end
  end
end
