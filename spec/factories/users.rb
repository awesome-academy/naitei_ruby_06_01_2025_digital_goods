FactoryBot.define do
  factory :user do
    user_name { Faker::Internet.username }
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    telephone { "0123456789" }
    password { "password123" }
    password_confirmation { "password123" }
    admin { false }
    status { 1 }
    confirmed_at { Time.current }

    trait :admin do
      admin { true }
    end
  end
end
