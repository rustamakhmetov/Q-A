require 'rails_helper'

describe Question do
  it {should belong_to :user}
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id}
  it { should accept_nested_attributes_for :attachments}

  describe "Attachments" do # the has_many association
    let(:user) { create(:user) }

    describe "save with" do
      it "valid attributes" do
        test_photo = ActionDispatch::Http::UploadedFile.new({
                    :filename => 'spec_helper.rb',
                    :tempfile => File.new("#{Rails.root}/spec/spec_helper.rb")
        })
        q = Question.new(attributes_for(:question).merge(user: user, attachments_attributes: [{file: test_photo}]))
        expect{ q.save }.to change(Question, :count).by(1).and change(Attachment, :count).by(1)
      end

      it 'invalid attributes' do
        q = Question.new(attributes_for(:question).merge(user: user, attachments_attributes: [{file: nil}]))
        expect{ q.save }.to change(Question, :count).by(1).and change(Attachment, :count).by(0)
      end
    end

    it "allows destroy attribute" do
      files = 3.times.collect do |i|
        ActionDispatch::Http::UploadedFile.new({
           :filename => "spec_helper#{i}.rb",
           :tempfile => File.new("#{Rails.root}/spec/spec_helper.rb") })
      end
      attachments_attributes = files.collect { |obj| {file: obj} }

      expect(Attachment.all.count).to eq 0
      q = Question.new(attributes_for(:question).merge(user: user, attachments_attributes: attachments_attributes))
      q.save
      expect(Question.all.count).to eq 1
      expect(Attachment.all.count).to eq 3

      attachments_attributes = q.attachments.each.collect { |a| {id: a.id, _destroy: "1"} }
      expect{
        q.attachments_attributes = attachments_attributes
        q.save
      }.to change(Question, :count).by(0).and change(Attachment, :count).by(-3)
    end
  end
end