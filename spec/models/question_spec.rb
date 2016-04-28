require 'rails_helper'

describe Question do
  it {should belong_to :user}
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
end