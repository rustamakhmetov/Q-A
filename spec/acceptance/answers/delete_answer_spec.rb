require 'acceptance/acceptance_helper'

feature 'Edit answer', %q{
  In order to be able to cancel answer
  As an author answer
  I want to be able to remove an answer to the question
} do
  given!(:question) { create(:question) }
  given!(:user) { question.user }

  describe 'Author' do
    given!(:answer) { create(:answer, question: question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see delete link' do
      within '.answers' do
        expect(page).to have_link('Delete')
      end
    end

    scenario 'delete answer', js: true do
      within '.answers' do
        expect(page).to have_selector("div#answer#{answer.id}")
        click_on 'Delete'
        wait_for_ajax
      end
      expect(page).to have_selector("div#flash_messages")
      expect(page).to have_content 'Ответ успешно удален.'
      within '.answers' do
        expect(page).to_not have_link('Delete')
        expect(page).to_not have_content(answer.body)
      end
    end
  end

  describe 'Non author' do
    given!(:answer) { create(:answer, question: question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see delete link" do
      within '.answers' do
        expect(page).to_not have_link('Delete')
      end
    end
  end

  describe 'Non-authenticated user' do
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'can not see delete link on answer of question' do
      visit question_path(question)
      expect(page).to_not have_link('Delete')
    end
  end
end