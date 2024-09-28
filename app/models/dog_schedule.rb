class DogSchedule < ApplicationRecord
  belongs_to :dog
  belongs_to :shift
  belongs_to :walker, class_name: 'User', foreign_key: 'user_id'

  enum status: { home: 0, in_van: 1, at_field: 2, on_way_home: 3, dropped_off: 4 }

  def not_in_past?
    return false if shift.blank?
    
    shift.date >= Date.today
  end
end
