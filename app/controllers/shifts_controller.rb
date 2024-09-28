class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show]

  def index
    @shifts = Shift.all
  end

  def show
    @shift = Shift.find(params[:id])
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end
end
