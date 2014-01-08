# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title ""
    description ""
    price ""
    in_stock false
  end
end
