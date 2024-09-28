class DogSchedulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      elsif user.dog_walker?
        scope.where(walker: user)
      elsif user.owner?
        scope.joins(:dog).where(dogs: { owner: user })
      else
        scope.none
      end
    end
  end

  def index?
    true
  end
end
