FactoryBot.define do
  factory :product do
    product_title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 10.0..1000.0, as_string: false) }
    discount { rand(0..50) }
    rating { rand(0.0..5.0).round(1) }
    color { Faker::Color.color_name }
    stock_quantity { rand(10..100) }
  end
end
