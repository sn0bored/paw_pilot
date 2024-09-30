class Dog < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :dog_schedules
  has_many :shifts, through: :dog_schedules
  has_one :dog_subscription
  # TODO: Add in geocoding for use on map
  # geocoded_by :full_street_address
  # after_validation :geocode, if: :address_changed?
  
  # TODO: Add in avatar for dog to make it easier to identify
  has_one_attached :avatar

  def last_walker
    dog_schedules.present? ? dog_schedules.last.walker.name : 'N/A'
  end

  def full_street_address
    "#{street_address}, #{city}, #{state}, #{zip_code}"
  end

  def address_changed?
    street_address_changed? || city_changed? || state_changed? || zip_code_changed?
  end

  def shift_length
    dog_subscription&.day_length || 'N/A'
  end

  def self.available_for_day(day_of_week)
    joins(:dog_subscription)
      .where("dog_subscriptions.#{day_of_week} = ?", true)
  end
end
