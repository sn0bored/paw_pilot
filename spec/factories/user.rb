FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    name { Faker::Name.name }

    trait :dog_walker do
      role { :dog_walker }
    end

    trait :manager do
      role { :manager }
    end

    trait :dog_owner do
      role { :dog_owner }
    end
  end
end