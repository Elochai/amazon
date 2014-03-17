# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    name "Name"
    number "12345"
    discount 0.5
  end
end
