require "rails_helper"

feature "User can view a list of questions", %q{
  In order to be able to solve my problem
  As an user
  I want to be able to view a list of questions
} do

  given(:user) do
    u = create(:user)
    open_email(u.email)
    current_email.click_link 'Confirm my account'
    u
  end

  scenario 'Authenticated user can view a list of questions' do
    sign_in(user)

    questions = create_list(:question, 5)
    visit questions_path
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end

  scenario 'Non-authenticated user can view a list of questions' do
    questions = create_list(:question, 5)
    visit questions_path
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end
