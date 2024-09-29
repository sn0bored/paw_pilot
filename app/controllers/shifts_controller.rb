class ShiftsController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization

  def index
    @shifts = policy_scope(Shift)
  end

  def show
    @shift = policy_scope(Shift).find(params[:id])
  end

  def edit
    @shift = Shift.includes(dog_schedules: [:dog, :walker]).find(params[:id])
    authorize @shift
  end

  def reassign_dog
    @shift = Shift.includes(dog_schedules: [:dog, :walker]).find(params[:id])
    authorize @shift
    
    dog_schedule = @shift.dog_schedules.find_by(dog_id: params[:dog_id])
    
    respond_to do |format|
      if dog_schedule.update(user_id: params[:new_walker_id])
        format.html { redirect_to edit_shift_path(@shift), notice: 'Dog reassigned successfully.' }
        format.turbo_stream
      else
        format.html do
          flash.now[:alert] = 'Failed to reassign dog.'
          render :edit, status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "shift_#{@shift.id}",
            partial: 'shifts/edit_shift',
            locals: { shift: @shift, error: 'Failed to reassign dog.' }
          ), status: :unprocessable_entity
        end
      end
    end
  end
end
