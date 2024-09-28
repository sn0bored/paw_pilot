class Van < ApplicationRecord
  has_many :assignments
  has_many :dog_walkers, through: :assignments, source: :user
  has_many :dogs, through: :assignments
end
