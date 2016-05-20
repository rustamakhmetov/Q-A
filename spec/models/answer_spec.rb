require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to :user}
  it {should belong_to :question}
  it {should have_many(:attachments).dependent(:destroy) }
  it {should validate_presence_of :body}
  it {should validate_presence_of :user_id}
  it {should validate_presence_of :question_id}
  it { should have_db_column(:accept) }
  it { should accept_nested_attributes_for :attachments }

  describe 'accept answer' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, id: 3) }
    let!(:answer2) { create(:answer, question: question, accept: true, id: 2) }
    let!(:answer3) { create(:answer, question: question, id: 1) }

    context 'with valid attributes'  do
      context 'accept answer1' do
        it { expect { answer1.accept! }.to change { answer1.reload.accept }.from(false).to(true) }
        it { expect { answer1.accept! }.to change { answer2.reload.accept }.from(true).to(false) }
        it { expect { answer1.accept! }.to_not change { answer3.reload.accept }.from(false) }
      end
    end

    context 'with invalid attributes'  do
      context 'answer not belongs to question' do
        subject { lambda { create(:answer, question: create(:question)).accept! } }

        it { should_not change { answer1.reload.accept }.from(false) }
        it { should_not change { answer2.reload.accept }.from(true) }
      end
    end
  end

  describe "Attachments" do # the has_many association
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    subject(:test_file) do
      lambda do
        ActionDispatch::Http::UploadedFile.new({
                                                   :filename => 'spec_helper.rb',
                                                   :tempfile => File.new("#{Rails.root}/spec/spec_helper.rb")
                                               })
      end
    end

    describe "save with" do
      it "valid attributes" do
        q = Answer.new(attributes_for(:answer).merge(user: user, question: question, attachments_attributes: [{file: test_file.call}]))
        expect{ q.save }.to change(Answer, :count).by(1).and change(Attachment, :count).by(1)
      end

      it 'invalid attributes' do
        q = Answer.new(attributes_for(:answer).merge(user: user, question: question, attachments_attributes: [{file: nil}]))
        expect{ q.save }.to change(Answer, :count).by(1).and change(Attachment, :count).by(0)
      end
    end

    it "allows destroy attribute" do
      attachments_attributes = 3.times.collect { {file: test_file.call } }

      expect(Attachment.all.count).to eq 0
      q = Answer.new(attributes_for(:answer).merge(user: user, question: question, attachments_attributes: attachments_attributes))
      q.save
      expect(Answer.all.count).to eq 1
      expect(Attachment.all.count).to eq 3

      attachments_attributes = q.attachments.each.collect { |a| {id: a.id, _destroy: "1"} }
      expect{
        q.attachments_attributes = attachments_attributes
        q.save
      }.to change(Answer, :count).by(0).and change(Attachment, :count).by(-3)
    end
  end
end
