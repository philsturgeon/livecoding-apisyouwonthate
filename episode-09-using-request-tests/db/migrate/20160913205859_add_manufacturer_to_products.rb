class AddManufacturerToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :manufacturer, index: true
  end
end
