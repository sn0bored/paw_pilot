module AuthenticationHelpers
  def login_as(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Unleash the Fun'
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :feature
end