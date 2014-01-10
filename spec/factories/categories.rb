# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    title "Fantasy"
    number_of_books 1
  end
end
