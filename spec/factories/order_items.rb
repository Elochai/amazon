# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item do
    quantity 1
    book FactoryGirl.create(:book)
  end
end
