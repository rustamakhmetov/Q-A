require 'acceptance/acceptance_helper'

feature 'Edit question', %q{
  In order to be able to update post
  As an authenticated user
  I want to be able to edit an question
} do
  #given!(:question) { create(:question_with_answers, answers_count: 1) }
  given(:user) { create(:user) }

  describe 'Author' do
    given!(:question) { create(:question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see edit link' do
      expect(page).to have_xpath('//a[@data-question-id="%s"]' % question.id) # Edit
    end

    scenario 'edit question', js: true do
      within '.question' do
        expect(page).to_not have_selector("textarea")
        find(:xpath, '//a[@data-question-id="%s"]' % question.id).click
        expect(page).to_not have_link('Edit')
        expect(page).to have_selector("textarea")
        fill_in 'Your question', with: 'new question'
        click_on 'Save'
        expect(page).to_not have_selector("textarea")
        expect(page).to have_xpath('//a[@data-question-id="%s"]' % question.id) # Edit
        expect(page).to_not have_content(question.body)
        expect(page).to have_content('new question')
      end
    end
  end

  describe 'Non author' do
    given!(:question) { create(:question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see edit link" do
      within '.question' do
        expect(page).to_not have_link('Edit')
      end
    end

    scenario "don't see update form" do
      within '.question' do
        expect(page).to_not have_selector("textarea")
        expect(page).to_not have_link('Save')
      end
    end

  end

end