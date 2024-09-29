FactoryBot.define do
  factory :assignment do
    association :user, factory: [:user, :dog_walker]
    association :shift
    association :van
  end
end