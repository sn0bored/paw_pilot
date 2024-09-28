class UsersController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization

  def index
    @users = policy_scope(User)
  end

end