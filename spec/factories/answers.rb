FactoryGirl.define do
  factory :answer do
    question
    body "MyText"
    #association :question, factory: :question, strategy: :build
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
