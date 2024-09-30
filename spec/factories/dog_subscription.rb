FactoryBot.define do
  factory :dog_subscription do
    association :dog
    monday { [true, false].sample }
    tuesday { [true, false].sample }
    wednesday { [true, false].sample }
    thursday { [true, false].sample }
    friday { [true, false].sample }
    day_length { 0 }
  end
end