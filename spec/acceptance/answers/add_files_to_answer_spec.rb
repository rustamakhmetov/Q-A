require 'acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given!(:question) {create(:question)}
  given(:user) { question.user }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks answer', js: true do
    fill_in 'Body', with: 'text text'
    within "#attachments" do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Ask answer'

    within ".answers" do
      expect(page).to have_link 'spec_helper.rb', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
    end
  end

  scenario 'User visual adds and remove multiple file fields when asks answer', js: true do
    click_on 'add file'
    within(:xpath, '//div[@id="attachments"]/div[@class="nested-fields"][2]') do
      click_on 'remove file'
    end
    expect(page).to_not have_selector(:xpath, '//div[@id="attachments"]/div[@class="nested-fields"][2]')
  end

  scenario 'User adds multiple files when asks answer', js: true do
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    within(:xpath, '//div[@id="attachments"]/div[@class="nested-fields"][2]') do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Ask answer'

    expect(page).to have_link 'spec_helper.rb', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/1/spec_helper.rb"
    expect(page).to have_link 'spec_helper.rb', href: "#{Rails.root}/spec/tmp/uploads/attachment/file/2/spec_helper.rb"
  end
end