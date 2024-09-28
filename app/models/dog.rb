class Dog < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :dog_schedules
  has_many :shifts, through: :dog_schedules
  has_one :dog_subscription
  
  has_one_attached :avatar

  def last_walker
    dog_schedules.present? ? dog_schedules.last.walker.name : 'N/A'
  end
end
