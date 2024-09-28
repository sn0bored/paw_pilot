class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { dog_owner: 0, dog_walker: 1, manager: 2 }

  has_many :dogs # if dog_owner
  has_many :assignments # if dog_walker or manager
  has_many :shifts, through: :assignments
  has_many :dog_schedules, foreign_key: 'user_id', dependent: :destroy
  has_many :assigned_dogs, through: :dog_schedules, source: :dog

  scope :walkers, -> { where(role: 'walker').or(where(role: 'manager')) }
end
