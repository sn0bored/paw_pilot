class DogSchedulesController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization

  def index
    @dog_schedules = policy_scope(DogSchedule)
    #
  end

  def edit_status
    @dog_schedule = DogSchedule.find(params[:id])
  end

  def update
    @dog_schedule = DogSchedule.find(params[:id])
    if @dog_schedule.update(dog_schedule_params)
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def dog_schedule_params
    params.require(:dog_schedule).permit(:status)
  end
end