require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #index' do
    it 'populates an array of all answers' do
      answer1 = FactoryGirl.create(:answer)
    end
  end
end
