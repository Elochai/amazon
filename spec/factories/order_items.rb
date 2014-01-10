# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item do
    price 50.00
    quantity 1
    book nil
    order nil
  end
end
