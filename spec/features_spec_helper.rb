def sign_in_that customer
  visit new_customer_session_path
  fill_in 'Email', with: customer.email
  fill_in 'Password', with: customer.password
  click_button 'Sign in'
end