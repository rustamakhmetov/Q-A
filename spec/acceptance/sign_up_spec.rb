require "rails_helper"

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
} do

  given(:user) do
    create(:user)
  end

  scenario 'Registered user try to sign up' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path

    visit new_user_registration_path
    expect(page).to have_content 'You are already signed in.'
  end

  scenario 'Non-registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Name', with: 'New user'
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Please follow the link to activate your account'

    open_email('new_user@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-registered user try to sign up with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content "Name can't be blank"
  end
end