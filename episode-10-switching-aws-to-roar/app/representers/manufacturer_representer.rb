require 'roar/decorator'

class ManufacturerRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI

  type :manufacturer

  property :id
  property :name
  property :about
  property :city
  property :country

  has_many :products

  link(:self)     { manufacturer_url(id) }
  link(:products) { products_url(manufacturer_id: id) }
end
