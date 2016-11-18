class Product < ActiveRecord::Base
  belongs_to :manufacturer

  validates :name, :description, presence: true
end
