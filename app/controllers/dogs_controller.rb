class DogsController < ApplicationController
  include Pundit::Authorization
  
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  def index
    @dogs = Dog.all
    authorize @dogs
  end

  def show
    @dog = Dog.find(params[:id])
    authorize @dog
  end

  def new
    @dog = Dog.new
    authorize @dog
  end

  def create
    @dog = Dog.new(dog_params)
    authorize @dog
    @dog.save
  end

  def edit
    authorize @dog
  end

  def update
    authorize @dog
    @dog.update(dog_params)
  end

  def destroy
    authorize @dog
    @dog.destroy
  end

  private

  def set_dog
    @dog = Dog.find(params[:id])
  end
    
end
