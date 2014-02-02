# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    email Faker::Internet.email
    password "abcd1234"
    firstname "Vasya"
    lastname "Pupkin"
  end
end
