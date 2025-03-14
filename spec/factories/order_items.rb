FactoryBot.define do
  factory :order_item do
    quantity { rand(1..10) }
    product
    order
  end
end
