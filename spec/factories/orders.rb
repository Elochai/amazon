# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    total_price ""
    state ""
    completed_at "MyString"
    date "MyString"
    bill_address "MyString"
    text "MyString"
    ship_address "MyString"
  end
end
