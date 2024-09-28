class DogSchedule < ApplicationRecord
  enum status: { home: 0, in_van: 1, at_field: 2, on_way_home: 3, dropped_off: 4 }

  belongs_to :dog
  belongs_to :shift
end
