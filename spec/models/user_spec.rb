require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe 'method author_of?' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    context 'with valid attributes'  do
      it 'author of Answer' do
        expect(user.author_of?(create(:answer, user: user))).to eq true
      end

      it 'non-author of Answer' do
        expect(user.author_of?(answer)).to eq false
      end
    end

    context 'with invalid attributes'  do
      it 'Answer with nil user_id' do
        answer.user_id = nil
        expect(user.author_of?(answer)).to eq false
      end

      it 'model is nil' do
        expect(user.author_of?(nil)).to eq false
      end

      it 'fake model without field user_id' do
        expect(user.author_of?("")).to eq false
      end
    end
  end
end
