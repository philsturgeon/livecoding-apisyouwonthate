class ManufacturerSerializer < ActiveModel::Serializer
  type :manufacturer

  attributes :id, :name, :about, :city, :country

  has_many :products

  link(:self)     { manufacturer_url(object) }
  link(:products) { products_url(manufacturer: object.id) }
end
