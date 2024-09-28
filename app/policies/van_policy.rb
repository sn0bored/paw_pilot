class VanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    true
  end
end