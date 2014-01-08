# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number ""
    cvv ""
    expiration_month ""
    expiration_year ""
    firstname ""
    lastname "MyString"
  end
end
