require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix msitake
  As an author of answer
  I'd like at be able to edit my answer
} do
  given(:user) do
    create(:user)
  end

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end
    scenario 'sees link to Edit' do
      #save_and_open_page
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      within ".answers" do
        expect(page).to_not have_selector("textarea")
        click_on 'Edit'
        expect(page).to have_selector("textarea")

        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector("textarea")
      end
    end

    scenario "try to edit other user's question"
  end
end