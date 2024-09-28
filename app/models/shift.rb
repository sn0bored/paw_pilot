class Shift < ApplicationRecord
  enum time_of_day: { morning: 0, afternoon: 1 }

  has_many :assignments
  has_many :dog_walkers, through: :assignments, source: :user
  has_many :dog_schedules
  has_many :dogs, through: :dog_schedules
end
