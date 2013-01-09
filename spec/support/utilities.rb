include ApplicationHelper

def sign_in(user)
  # Sign in using Capybara
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
