require 'acceptance/acceptance_helper'

feature 'Delete attachments from answer', %q{
  In order to delete attachments from my answer
  As an answer's author
  I'd like to be able to delete attachment files
} do

  given!(:question) {create(:question)}
  given(:user) { question.user }

  describe 'Author of answer may' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see link to remove file', js: true do
      fill_in 'Body', with: 'text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Ask answer'
      within "#answer1" do
        expect(page).to_not have_link("remove file")
        within "#attachment1" do
          expect(page).to have_link '', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
        end
      end
      within "#answer1" do
        click_on 'Edit'
        expect(page).to have_link("remove file")
      end
    end

    scenario 'delete file', js: true do
      fill_in 'Body', with: 'text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Ask answer'
      wait_for_ajax
      within "#answer1" do
        expect(page).to_not have_link("remove file")
        within "#attachment1" do
          expect(page).to have_link '', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
        end
      end
      within "#answer1" do
        click_on 'Edit'
        wait_for_ajax
        fill_in 'Your answer', with: question.answers.first.body
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
    question1 = create(:question_with_answers, answers_count: 1)
    answer = question1.answers.first
    answer.update(attachments_attributes: [{file: test_file}])
    visit question_path(question1)
    within "#answer1" do
      expect(page).to_not have_link("Edit")
      expect(page).to_not have_link("remove file")
    end
  end


end