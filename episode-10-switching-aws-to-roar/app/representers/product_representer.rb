require 'roar/decorator'
# require 'roar/json/json_api'

class ProductRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI
  # include Roar::Hypermedia

  type :product

  property :id
  property :name
  property :description
  # property :product_type, as: :type
  property :apv
  property :image_url

  # has_one :manufacturer

  # decorator: ClassName
  # has_one :author, class: Author, populator: ::Representable::FindOrInstantiate do # populator is for parsing, only.
  #   type :authors
  #
  #   property :id
  #   property :email
  #   link(:self) { "http://authors/#{represented.id}" }
  # end

  # link(:self) { product_url(id) }
  # link(:manufacturer) { manufacturer_url(manufacturer) }
end
