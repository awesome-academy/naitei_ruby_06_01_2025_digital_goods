FactoryBot.define do
  factory :user_address do
    location { Faker::Address.full_address }
    user
    province
    district
    ward
    address_default { false }

    trait :default do
      address_default { true }
    end
  end
end
