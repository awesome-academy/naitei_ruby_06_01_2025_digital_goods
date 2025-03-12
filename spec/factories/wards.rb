FactoryBot.define do
  factory :ward do
    name { Faker::Address.street_name }
    district
  end
end
