require 'rails_helper'

feature 'Removal of the author questions and answers', %q{
  In order to be able to remove my questions and answers
  As an authenticated user
  I want to be able to remove my questions and answers
} do

  given(:user) do
    u = create(:user)
    open_email(u.email)
    current_email.click_link 'Confirm my account'
    u
  end

  given(:question) do
    create(:question_with_answers, user: user)
  end

  scenario 'Authenticated author delete your question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Вопрос успешно удален.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated author delete your answer' do
    sign_in(user)

    qpath = question_path(question)
    visit qpath
    click_on "Delete answer #{question.answers.first.id}"
    expect(page).to have_content 'Ответ успешно удален.'
    expect(current_path).to eq qpath
  end

  scenario 'Authenticated author can not delete other question' do
    sign_in(user)

    qpath = question_path(create(:question, user: create(:user)))
    visit qpath
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Authenticated author can not delete other answer' do
    sign_in(user)

    answer = create(:answer, user: create(:user), question: question)
    visit question_path(question)
    expect(page).to_not have_link "Delete answer #{answer.id}"
  end
end