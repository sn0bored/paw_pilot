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
    @available_dogs = Dog.available_for_day(@shift.date.strftime('%A').downcase)
                         .where.not(id: @shift.dogs.pluck(:id))
  end

  def reassign_dog
    @shift = Shift.includes(dog_schedules: [:dog, :walker]).find(params[:id])
    authorize @shift
    
    new_walker = User.find(params[:new_walker_id])
    
    # Check van capacity
    if new_walker.dogs_for_shift(@shift).count >= Van::DEFAULT_CAPACITY
      return
    end
    
    dog_schedule = @shift.dog_schedules.find_by(dog_id: params[:dog_id])
    
    if dog_schedule
      # Update existing dog schedule
      if dog_schedule.update(user_id: params[:new_walker_id])
        render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift })
      else
        render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift, error: 'Failed to reassign dog.' }), status: :unprocessable_entity
      end
    else
      # Create new dog schedule
      new_dog_schedule = @shift.dog_schedules.new(dog_id: params[:dog_id], user_id: params[:new_walker_id])
      if new_dog_schedule.save
        render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift })
      else
        render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift, error: 'Failed to assign dog to shift.' }), status: :unprocessable_entity
      end
    end
  end

  def unassign_dog
    @shift = Shift.includes(dog_schedules: [:dog, :walker]).find(params[:id])
    authorize @shift
    
    dog_schedule = @shift.dog_schedules.find_by(dog_id: params[:dog_id])
    if dog_schedule&.destroy
      render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift })
    else
      render turbo_stream: turbo_stream.replace("shift_#{@shift.id}", partial: 'shifts/edit_shift', locals: { shift: @shift, error: 'Failed to unassign dog.' }), status: :unprocessable_entity
    end
  end

  def new
    @shift = Shift.new
    authorize @shift
  end

  def create
    @shift = Shift.new(shift_params)
    authorize @shift

    if @shift.save
      redirect_to edit_shift_path(@shift), notice: 'Shift was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    authorize @shift

    @shift.destroy
    redirect_to shifts_path, notice: 'Shift was successfully deleted.'
  end

  private

  def shift_params
    params.require(:shift).permit(:date, :time_of_day)
  end
end
