FactoryBot.define do
  factory :order do
    total_price { Faker::Commerce.price(range: 50.0..5000.0) }
    delivery_fee { Faker::Commerce.price(range: 0.0..50.0) }
    payment_status { false }
    status { rand(0..3) }
    notice { Faker::Lorem.sentence }
    reason_cancel { nil }
    user
    user_address

    trait :paid do
      payment_status { true }
    end

    trait :canceled do
      reason_cancel { "Customer request" }
    end
  end
end
