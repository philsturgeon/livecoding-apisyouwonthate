class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :body
      t.string :rating
      t.string :name

      t.timestamps
    end
  end
end
