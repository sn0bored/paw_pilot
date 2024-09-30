class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_walker!

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @morning_shift = Shift.find_by(date: @date, time_of_day: 'morning')
    @afternoon_shift = Shift.find_by(date: @date, time_of_day: 'afternoon')

    @morning_dog_schedules = current_user.dog_schedules.where(shift: @morning_shift)
    @afternoon_dog_schedules = current_user.dog_schedules.where(shift: @afternoon_shift)

    @can_add_shifts = current_user.manager? && (!@morning_shift || !@afternoon_shift)
  end

  private

  def ensure_walker!
    unless current_user.dog_walker? || current_user.manager?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
