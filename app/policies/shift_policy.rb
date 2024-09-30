class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    true
  end

  def edit?
    @user.manager?
  end

  def reassign_dog?
    @user.manager?
  end

  def new?
    @user.manager?
  end

  def create?
    @user.manager?
  end

  def destroy?
    @user.manager?
  end

  def ai_optimize?
    @user.manager?
  end

  def geo_optimize?
    @user.manager?
  end
end
