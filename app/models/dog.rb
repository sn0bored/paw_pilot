class Dog < ApplicationRecord
  belongs_to :user # This is the dog owner
  has_many :dog_schedules
  has_many :shifts, through: :dog_schedules
end
