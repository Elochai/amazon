# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    total_price 50.00
    state "in progress"
    completed_at nil
    association :bill_address, factory: :address 
    association :ship_address, factory: :address 

    factory :order_with_items do
      ignore { order_items_count 2 }
      after :create do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
      end
    end
  end
end
