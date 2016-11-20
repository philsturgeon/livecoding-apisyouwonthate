class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :product_type
      t.float :apv
      t.string :image_url

      t.timestamps
    end
  end
end
