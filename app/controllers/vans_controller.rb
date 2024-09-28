class VansController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization

  def index
    @vans = policy_scope(Van)
  end

end