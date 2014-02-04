# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    email "user@gmail.com"
    password "12345678"
    firstname "Vasya"
    lastname "Pupkin"
  end
end
