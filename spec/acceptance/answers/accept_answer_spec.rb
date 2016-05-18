require 'acceptance/acceptance_helper'

feature 'Accept answer', %q{
  In order to be able to accept right answer solved problem
  As an author of question
  I want to be able to accept an answer to the question
} do

  describe 'Author of question' do
    given(:question) { create(:question) }
    given(:user) { question.user  }
    given!(:answer) { create(:answer, question: question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see accept link' do
      within '.answers' do
        expect(page).to have_link('Accept')
      end
    end

    scenario 'accept answer', js: true do
      within '.answers' do
        expect(page).to have_selector("div#answer#{answer.id}")
        click_on 'Accept'
        wait_for_ajax
      end
      within '.answers' do
        expect(page).to_not have_link('Accept')
        expect(page).to have_selector("div.accept")
      end
    end
  end

  describe 'Non author of question' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: create(:user))}
    given!(:answer) { create(:answer, question: question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see accept link" do
      within '.answers' do
        expect(page).to_not have_link('Accept')
      end
    end
  end

  describe 'Non-authenticated user' do
    given(:question) { create(:question) }
    given(:user) { question.user  }
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'can not see accept link on answer of question' do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link('Accept')
      end
    end
  end
end