FactoryBot.define do
  factory :shift do
    date { Date.today }
    time_of_day { :morning }
  end
end