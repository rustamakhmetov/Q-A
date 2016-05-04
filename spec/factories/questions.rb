FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    title
    body "MyText"
    factory :question_with_answers do
      ignore do
        answers_count 5
      end
      after :create do |question, evaluator|
        FactoryGirl.create_list(:answer, evaluator.answers_count, :question => question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
