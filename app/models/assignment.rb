class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :shift
  belongs_to :van
end
