require 'rails_helper'

RSpec.describe "Manager Functionality", type: :feature do
  let(:manager) { create(:user, :manager) }
  let(:walker1) { create(:user, :dog_walker) }
  let(:walker2) { create(:user, :dog_walker) }
  let(:van1) { create(:van) }
  let(:van2) { create(:van) }
  let(:shift) { create(:shift, date: Date.today, time_of_day: :morning) }
  let!(:assignment1) { create(:assignment, user: walker1, shift: shift, van: van1) }
  let!(:assignment2) { create(:assignment, user: walker2, shift: shift, van: van2) }
  let!(:dog1) { create(:dog, :with_subscription) }
  let!(:dog2) { create(:dog, :with_subscription) }
  let!(:dog_schedule1) { create(:dog_schedule, dog: dog1, shift: shift, walker: walker1) }
  let!(:dog_schedule2) { create(:dog_schedule, dog: dog2, shift: shift, walker: walker2) }

  before do
    login_as(manager)
  end

  describe "viewing walker schedules" do
    it "allows managers to see all dog walkers' schedules" do
      visit shifts_path
      expect(page).to have_content(shift.date.to_s)
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
      expect(page).to have_content(dog1.name)
      expect(page).to have_content(dog2.name)
    end
  end

  describe "managing dog assignments" do
    it "allows managers to assign a dog to a different walker" do
      visit edit_dog_schedule_path(dog_schedule1)
      select walker2.name, from: 'Walker'
      click_button 'Update Dog Schedule'
      expect(page).to have_content("Dog Schedule was successfully updated")
      expect(dog_schedule1.reload.walker).to eq(walker2)
    end

    it "allows managers to remove a dog from a walker" do
      visit edit_dog_schedule_path(dog_schedule1)
      select 'Unassigned', from: 'Walker'
      click_button 'Update Dog Schedule'
      expect(page).to have_content("Dog Schedule was successfully updated")
      expect(dog_schedule1.reload.walker).to be_nil
    end
  end
end