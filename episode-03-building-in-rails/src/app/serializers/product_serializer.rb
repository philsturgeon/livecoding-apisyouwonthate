class ProductSerializer < ActiveModel::Serializer
  type :product

  attributes :id, :name, :description, :type, :apv, :image_url

  belongs_to :manufacturer

  link(:self)         { product_url(object) }
  link(:manufacturer) { manufacturer_url(object) }

  def type
    object.product_type
  end
end
