require 'rails_helper'

RSpec.describe "Manager", type: :feature do
  let(:manager) { create(:user, :manager) }
  let(:walker1) { create(:user, :dog_walker) }
  let(:walker2) { create(:user, :dog_walker) }
  let(:shift) { create(:shift, date: Date.today, time_of_day: :morning) }
  let(:dog1) { create(:dog, owner: create(:user)) }
  let(:dog2) { create(:dog, owner: create(:user)) }
  let(:dog_subscription1) { create(:dog_subscription, dog: dog1, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true) }
  let(:dog_subscription2) { create(:dog_subscription, dog: dog2, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true) }

  
  before do
    login_as(manager)
    
    # Create dog schedules for the shift
    create(:dog_schedule, shift: shift, dog: dog1, walker: walker1)
    create(:dog_schedule, shift: shift, dog: dog2, walker: walker2)
  end

  describe "can view all shifts" do
    it "displays all shifts" do
      visit shifts_path
      
      expect(page).to have_content(shift.date.strftime('%A, %B %d'))
      expect(page).to have_content(shift.time_of_day.titleize)
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
    end
  end

  describe "can create a new shift" do
    it "creates a new shift and add dogs to walkers" do
      visit shifts_path
      click_link 'New Shift'

      expect(page).to have_current_path(new_shift_path)

      fill_in 'Date', with: Date.tomorrow
      select 'morning', from: 'Time of day'
      click_button 'Create Shift'

      expect(page).to have_current_path(edit_shift_path(Shift.last))
      expect(page).to have_content("Edit Shift")
      expect(page).to have_content("Available Dogs")
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
    end
  end
end