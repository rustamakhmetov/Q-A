require 'rails_helper'

feature "View question and associated answers", %q{
  In order to be able solved my problem
  As an user
  I want to be able to view the question and answers to it
} do
  given(:user) do
    u = create(:user)
    open_email(u.email)
    current_email.click_link 'Confirm my account'
    u
  end

  let(:question) { create(:question_with_answers) }

  scenario 'Authenticated user can view question and associated answers' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated user can view question and associated answers' do
    visit question_path(question)
    click_on 'Ask answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end