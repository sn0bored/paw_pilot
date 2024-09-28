class Van < ApplicationRecord
  has_many :assignments
  has_many :dog_walkers, through: :assignments, source: :user
  has_many :dogs, through: :assignments

  before_save :set_default_capacity

  DEFAULT_CAPACITY = 12

  private

  def set_default_capacity
    self.capacity = DEFAULT_CAPACITY if capacity.blank?
  end
end
