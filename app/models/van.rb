class Van < ApplicationRecord
  has_many :assignments
  has_many :dog_walkers, through: :assignments, source: :user
  before_save :set_default_capacity

  DEFAULT_CAPACITY = 12

  def last_dog_walker
    assignments.last.user.name
  end

  private

  def set_default_capacity
    self.capacity = DEFAULT_CAPACITY if capacity.blank?
  end
end
