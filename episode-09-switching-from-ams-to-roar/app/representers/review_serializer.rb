class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :name
end
