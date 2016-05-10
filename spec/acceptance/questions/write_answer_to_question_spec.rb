require "rails_helper"

feature "Write answer to question", %q{
  In order to be able to help solve the problem
  As an user
  I want to be able to write an answer to the question
} do

  given(:user) do
    create(:user)
  end

  given!(:question) { create(:question) }

  scenario 'Authenticated user answer to question', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Body', with: 'text text'
    click_on 'Ask answer'
    expect(page).to have_content 'Ответ успешно добавлен'
    within '.answers' do
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Authenticated user answer (with invalid attributes) to question', js:true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    click_on 'Ask answer'
    expect(page).to_not have_content 'Ответ успешно добавлен'
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Non-authenticated user can not answer to question' do
    visit question_path(question)
    click_on 'Ask answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end