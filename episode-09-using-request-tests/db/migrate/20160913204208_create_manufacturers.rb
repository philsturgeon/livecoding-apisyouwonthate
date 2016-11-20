class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.string :about
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
