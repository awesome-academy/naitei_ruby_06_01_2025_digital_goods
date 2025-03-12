FactoryBot.define do
  factory :district do
    name { Faker::Address.city }
    province
  end
end
