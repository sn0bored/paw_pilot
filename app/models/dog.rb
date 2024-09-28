class Dog < ApplicationRecord
  belongs_to :user # This is the dog owner
  has_many :dog_schedules
  has_many :shifts, through: :dog_schedules
  has_one :dog_subscription
  
  has_one_attached :avatar
end
