require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#flash messages" do
    before do
      helper.flash_message(:error, "Error")
    end

    it "displays flash messages" do
      # helper is an instance of ActionView::Base configured with the
      # ApplicationHelper and all of Rails' built-in helpers
      expect(helper.flash_messages).to eq nil
    end

    describe 'fill flash messages from model errors' do
      it 'with valid attributes' do
        answer = create(:answer)
        answer.update(body: nil)
        helper.errors_to_flash(answer)
        expect(flash[:error]).to match_array(["Error", "Body can't be blank"])
      end

      describe 'with invalid attributes' do
        it 'model is nil' do
          helper.errors_to_flash(nil)
          expect(flash[:error]).to match_array(["Error"])
        end

        it 'model without field errors' do
          helper.errors_to_flash("111")
          expect(flash[:error]).to match_array(["Error"])
        end
      end
    end
  end
end