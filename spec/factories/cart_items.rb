FactoryBot.define do
  factory :cart_item do
    quantity { rand(1..5) }
    product
    user
    checked { false }

    trait :default do
      checked { true }
    end
  end
end
