# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'
FactoryGirl.define do
  factory :credit_card do
    number Faker::Business.credit_card_number
    cvv 2144
    expiration_month 12
    expiration_year 12
    firstname "Vasya"
    lastname "Pupkin"
    customer nil
  end
end
