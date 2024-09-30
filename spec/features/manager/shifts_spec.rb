require 'rails_helper'

RSpec.describe "Manager", type: :feature do
  let(:manager) { create(:user, :manager) }
  let(:walker1) { create(:user, :dog_walker) }
  let(:walker2) { create(:user, :dog_walker) }
  let(:shift) { create(:shift, date: Date.new(2024, 1, 1), time_of_day: :morning) }
  let(:dog1) { create(:dog, owner: create(:user)) }
  let(:dog2) { create(:dog, owner: create(:user)) }
  let(:dog3) { create(:dog, owner: create(:user)) }
  let(:dog_subscription1) { create(:dog_subscription, dog: dog1, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, day_length: 1) }
  let(:dog_subscription2) { create(:dog_subscription, dog: dog2, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, day_length: 1) }
  let(:dog_subscription3) { create(:dog_subscription, dog: dog3, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, day_length: 1) }
  let(:available_dog) { create(:dog, owner: create(:user)) }
  let(:dog_subscription) { create(:dog_subscription, dog: available_dog, monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, day_length: 1) }

  before do
    login_as(manager)
    
    # Create dog schedules for the shift
    create(:dog_schedule, shift: shift, dog: dog1, walker: walker1)
    create(:dog_schedule, shift: shift, dog: dog2, walker: walker2)
    
    # Ensure there's an available dog
    dog_subscription
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
    it "can add morning shift button" do
      visit root_path
      expect(page).to have_content("Add Morning Shift")
      click_button "Add Morning Shift"
      expect(page).to have_current_path(edit_shift_path(Shift.last))
      expect(page).to have_content("Edit Shift")
      expect(page).to have_content("Available Dogs")
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
      
    end

    it "creates a new shift and add dogs to walkers" do
      visit shifts_path
      click_link 'New Shift'

      expect(page).to have_current_path(new_shift_path)

      fill_in 'Date', with: Date.tomorrow
      select 'morning', from: 'Time of day'
      click_button 'Create Shift'
      expect(page).to have_content("Edit Shift")
      expect(page).to have_content("Available Dogs")
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
    end
  end

  xdescribe "can edit an existing shift" do
    it "allows dragging and dropping a dog to assign it to a walker", js: true do
      visit edit_shift_path(shift)
      
      # Wait for the page to load completely
      expect(page).to have_css('.available-dogs-list', wait: 10)
      expect(page).to have_css('.dog-list', count: User.where(role: [:dog_walker, :manager]).count, wait: 10)

      # Find the available dog and the first walker's list
      available_dog_element = find('.available-dogs-list .dog-item', match: :first)
      first_walker_list = find('.drop-area', match: :first)
      
      # Store the dog's information and the walker's name
      dog_info = available_dog_element.text
      walker_name = first_walker_list.sibling('.text-lg').text

      # Perform the drag and drop
      available_dog_element.drag_to(first_walker_list)

      # Wait for the drag and drop to complete and verify the dog is in the walker's list
      expect(page).to have_css('.dog-list .dog-item', text: dog_info, wait: 10)

      # Check that the dog is now in the walker's list
      within(first_walker_list) do
        expect(page).to have_content(dog_info)
      end

      # Check that the dog is no longer in the available dogs list
      within('.available-dogs-list') do
        expect(page).not_to have_content(dog_info)
      end

      # Refresh the page to ensure the change was saved
      visit edit_shift_path(shift)

      # Check that the dog is still in the correct walker's list
      within("h2:contains('#{walker_name}') + .dog-list") do
        expect(page).to have_content(dog_info)
      end

      # Double-check that the dog is not in the available dogs list
      within('.available-dogs-list') do
        expect(page).not_to have_content(dog_info)
      end
    end
  end
end
