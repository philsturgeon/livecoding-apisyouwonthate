FactoryGirl.define do
  factory :product do
    name 'Katies'
    description 'Unnecessarily strong fizzy cider that sells for the same price as normal ciders.'
    product_type 'cider'
    apv 7.6

    manufacturer
  end
end
