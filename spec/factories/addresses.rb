# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address ""
    zipcode ""
    city ""
    phone ""
    country "MyString"
  end
end
