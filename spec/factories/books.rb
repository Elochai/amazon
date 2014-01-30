# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "Lord of the rings: Fellowship of the ring"
    description "Cool story, bro"
    price 50.00
    in_stock 4
    category_id nil
    author_id nil
  end
end
