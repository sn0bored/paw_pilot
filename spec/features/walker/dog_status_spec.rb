require 'rails_helper'

RSpec.describe "Walker", type: :feature do
  let(:walker1) { create(:user, :dog_walker) }
  let(:shift) { create(:shift, date: Date.today, time_of_day: :morning) }
  let!(:dog1) { create(:dog, :with_subscription) }
  let!(:dog_schedule1) { create(:dog_schedule, dog: dog1, shift: shift, walker: walker1) }

  before do
    login_as(walker1)
  end

  describe "Dog Walker Functionality" do
    it "allows dog walkers to update a dog's status" do
      visit root_path(date: Date.today)
      within "[data-testid='dog-schedule-card-#{dog_schedule1.id}']" do
        click_on 'Edit'
        select 'In van', from: 'dog_schedule[status]'
        click_button 'Update'
      end

      expect(page).to have_content("Dog status updated successfully")
      expect(dog_schedule1.reload.status).to eq('in_van')
    end

    it "displays all possible statuses for a dog" do
      visit root_path(date: Date.today)
      
      within "[data-testid='dog-schedule-card-#{dog_schedule1.id}']" do
        expect(page).to have_select('dog_schedule[status]', options: [
          'Home',
          'In van',
          'At field',
          'On way home',
          'Dropped off'
        ])
      end
    end
  end
end