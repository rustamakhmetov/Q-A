require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to :user}
  it {should belong_to :question}
  it {should validate_presence_of :body}
  it {should validate_presence_of :user_id}
  it {should validate_presence_of :question_id}
  it { should have_db_column(:accept) }

  describe 'accept answer' do
    let(:question) { create(:question) }
    let(:answer1) { create(:answer, question: question, id: 3) }
    let(:answer2) { create(:answer, question: question, accept: true, id: 2) }
    let(:answer3) { create(:answer, question: question, id: 1) }

    context 'with valid attributes'  do
      context 'accept answer1' do
        subject { lambda { answer1.accept! } }

        it { should change { answer1.reload.accept }.from(false).to(true) }
        it { should change { answer2.reload.accept }.from(true).to(false) }
      end
    end

    context 'with invalid attributes'  do
      # context 'answer is nil' do
      #   subject { lambda { question.accept(nil) } }
      #
      #   it { should_not change { answer1.reload.accept }.from(false) }
      #   it { should_not change { answer2.reload.accept }.from(true) }
      # end

      context 'answer not belongs to question' do
        subject { lambda { create(:answer, question: create(:question)).accept! } }

        it { should_not change { answer1.reload.accept }.from(false) }
        it { should_not change { answer2.reload.accept }.from(true) }
      end
    end
  end
end
