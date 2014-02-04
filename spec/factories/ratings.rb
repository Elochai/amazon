# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating 10
    text {Faker::Lorem.sentence}
    customer nil
    book nil
  end
end
