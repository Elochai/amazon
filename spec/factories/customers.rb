# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'
FactoryGirl.define do
  factory :customer do
    email Faker::Internet.email
    password Faker::Internet.password
    firstname "Vasya"
    lastname "Pupkin"
  end
end
