FactoryGirl.define do
  factory :user do
    name "MyString"
  end

  factory :invalid_user, class: "User" do
    name nil
  end
end
