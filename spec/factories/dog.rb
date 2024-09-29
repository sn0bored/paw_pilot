FactoryBot.define do
  factory :dog do
    name { Faker::Creature::Dog.name }
    breed { Faker::Creature::Dog.breed }
    age { rand(1..10) }
    association :owner, factory: [:user, :dog_owner]
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    latitude { Faker::Number.between(from: 40.5774, to: 40.9176) }
    longitude { Faker::Number.between(from: -74.15, to: -73.7004) }

    trait :with_subscription do
      after(:create) do |dog|
        create(:dog_subscription, dog: dog)
      end
    end
  end
end