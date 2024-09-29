FactoryBot.define do
  factory :van do
    sequence(:name) { |n| "Van ##{n}" }
    capacity { 12 }
  end
end