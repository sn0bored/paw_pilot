class DogSubscription < ApplicationRecord
  belongs_to :dog

  enum day_length: {
    full: 0,
    morning: 1,
    afternoon: 2
  }
end
