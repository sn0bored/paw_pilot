class DogPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    @user.manager?
  end

  def show?
    @user.manager?
  end

  def new?
    @user.manager?
  end
end
