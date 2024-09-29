FactoryBot.define do
  factory :dog_schedule do
    association :dog
    association :shift
    association :walker, factory: [:user, :dog_walker]
    status { :home }
  end
end