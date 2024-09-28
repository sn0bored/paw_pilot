class DogSchedule < ApplicationRecord
  belongs_to :dog
  belongs_to :shift
end
