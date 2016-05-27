require 'acceptance/acceptance_helper'

feature 'Delete attachments from question', %q{
  In order to delete attachments from my question
  As an question's author
  I'd like to be able to delete attachment files
} do

  given!(:question) {create(:question)}
  given(:user) { question.user }

  describe 'Author of question may' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'see link to remove file', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      within ".question" do
        expect(page).to_not have_link("remove file")
        expect(page).to have_link '', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
        click_on 'Edit'
        wait_for_ajax
        expect(page).to have_link("remove file")
      end
    end

    scenario 'delete file', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      within ".question" do
        expect(page).to_not have_link("remove file")
        expect(page).to have_link '', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
        click_on 'Edit'
        click_on 'remove file'
        click_on 'Save'
        wait_for_ajax
        expect(page).to_not have_link("remove file")
        expect(page).to_not have_link '', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
      end
    end
  end

  scenario 'Not the author of the answer can not delete files', js: true do
    test_file = ActionDispatch::Http::UploadedFile.new({
                                               :filename => 'spec_helper.rb',
                                               :tempfile => File.new("#{Rails.root}/spec/spec_helper.rb")
                                           })
    sign_in(create(:user))
    question.update(attachments_attributes: [{file: test_file}])
    visit question_path(question)
    within ".question" do
      expect(page).to_not have_link("Edit")
      expect(page).to_not have_link("remove file")
    end
  end
end