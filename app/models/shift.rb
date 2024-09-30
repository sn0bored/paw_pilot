class Shift < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :dog_walkers, through: :assignments, source: :user
  has_many :dog_schedules, dependent: :destroy
  has_many :dogs, through: :dog_schedules
  has_many :walkers, -> { distinct }, through: :dog_schedules, source: :walker

  enum time_of_day: { morning: 0, afternoon: 1 }

  def pretty_time
    "#{date.strftime('%A, %B %d')} | #{time_of_day&.titleize}"
  end
end
