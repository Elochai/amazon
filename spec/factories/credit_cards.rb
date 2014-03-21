# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number '1234567890111'
    cvv '2144'
    expiration_month 12
    expiration_year Time.now.year
    firstname "Vasya"
    lastname "Pupkin"
    customer nil
    order nil
  end
end
