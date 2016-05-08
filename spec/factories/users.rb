FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    name "MyString"
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.now
  end

  factory :invalid_user, class: "User" do
    name nil
  end
end
