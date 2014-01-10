# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'
FactoryGirl.define do
  factory :address do
    address Faker::Address.street_name 
    zipcode Faker::Address.zip_code 
    city Faker::Address.city 
    phone Faker::PhoneNumber.phone_number 
    country nil
  end
end
