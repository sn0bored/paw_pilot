require 'rails_helper'

RSpec.describe "Manager", type: :feature do
  let(:manager) { create(:user, :manager) }
  let(:walker1) { create(:user, :dog_walker) }
  let(:walker2) { create(:user, :dog_walker) }

  before do
    login_as(manager)
  end

  describe "can view all users" do
    it "displays all users" do
      visit users_path
      expect(page).to have_content(manager.name)
      expect(page).to have_content(walker1.name)
      expect(page).to have_content(walker2.name)
    end
  end
end